//
//  ModifyProfileViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/22.
//

import UIKit
import SnapKit
import YPImagePicker

protocol ModifyProfileViewControllerDelegate: AnyObject {
    func dismissView()
}

class ModifyProfileViewController: UIViewController {
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        $0.image = UIImage(named: "defaultProfile")
        $0.layer.cornerRadius = 55
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var setImageView: ProfileSetImageView = {
        $0.layer.cornerRadius = 35 / 2
        $0.clipsToBounds = true
        $0.delegate = self
        return $0
    }(ProfileSetImageView())
    
    private let nicknameLabel: UILabel = {
        $0.text = "닉네임"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let inputNicknameView: UIView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.systemGray3.cgColor
        return $0
    }(UIView())
    
    private let nicknameTextField: UITextField = {
        $0.backgroundColor = .clear
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
        $0.smartDashesType = .no
        $0.autocorrectionType = .no
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return $0
    }(UITextField())
    
    var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.wordings.libraryTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        config.wordings.cancel = "취소"
        config.wordings.next = "완료"
        config.colors.tintColor = .black
        return config
    }()
    
    weak var delegate: ModifyProfileViewControllerDelegate?
    private var selectedProfileImage: UIImage?
    private var textfieldString = ""
    
    // MARK: - Life Cycles
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        profileImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    // MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        configureNavBar()
        
        view.addSubview(profileImageView)
        view.addSubview(setImageView)
        view.addSubview(nicknameLabel)
        view.addSubview(inputNicknameView)
        inputNicknameView.addSubview(nicknameTextField)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(26)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(110)
        }
        setImageView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.height.width.equalTo(35)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).inset(-42)
            make.leading.equalToSuperview().inset(20)
        }
        inputNicknameView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).inset(-26)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Functions
    private func configureNavBar() {
        title = "프로필 수정하기"
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonTap))
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let completeButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonTap))
        self.navigationItem.rightBarButtonItem = completeButtonItem
    }
    
    // MARK: - Handler
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.dismissView()
    }
    
    @objc func completeButtonTap() {
        // 기본 프로필일 때 기본프로필로 변경
        if profileImageView.image == UIImage(named: "defaultProfile") {
            ProfileNetworkManager.shared.deleteProfileImageRequest { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.delegate?.dismissView()
            }
        } else {
            guard let selectedProfileImage = selectedProfileImage else { return }
            ProfileNetworkManager.shared.updateProfileImageRequest(image: selectedProfileImage, nickname: textfieldString) { [weak self] b in
                if b {
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.dismissView()
                } else {
                    self?.navigationController?.popViewController(animated: true)
                    // Toast 실패
                }
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textfieldString = textField.text ?? ""
        print(textfieldString)
    }
    
}

extension ModifyProfileViewController: ProfileSetImageViewDelegate {
    func presentAlbum() {
        let actionSheet = UIAlertController(title: "프로필 사진 편집", message: nil, preferredStyle: .actionSheet)
        
        let selectPhoto = UIAlertAction(title: "앨범에서 사진 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let picker = YPImagePicker(configuration: self.config)
            picker.didFinishPicking { [ weak self, unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    self?.selectedProfileImage = photo.image
                    self?.profileImageView.image = photo.image
                }
                picker.dismiss(animated: true, completion: nil)
            }
            self.present(picker, animated: true, completion: nil)
        }
        let defaultPhoto = UIAlertAction(title: "기본 이미지로 변경", style: .default) { [weak self] _ in
            self?.profileImageView.image = UIImage(named: "defaultProfile")
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(selectPhoto)
        actionSheet.addAction(defaultPhoto)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}
