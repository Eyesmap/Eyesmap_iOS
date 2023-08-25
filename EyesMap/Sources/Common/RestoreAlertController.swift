//
//  RestoreAlertController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/19.
//

import UIKit
import SnapKit
import YPImagePicker

protocol RestoreAlertControllerProtocol: AnyObject {
    func uploadImage(images: [UIImage])
}

class RestoreAlertController: UIViewController {
    
    var selectedProfileImages: [UIImage] = []
    var selectedImage: [YPMediaItem] = []
    
    //MARK: - Properties
    private let backgroudView: UIView = {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
        return $0
    }(UIView())
    
    private lazy var containerView: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 13
        return $0
    }(UIView())
    
    private let dismissButton: UIView = {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 24 / 2
        
        let btn: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(dismissTap), for: .touchUpInside)
            return button
        }()
        
        $0.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(11)
        }
        
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.text = "복구 완료된 사진을 올려주세요"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let phoneImageButton: UIButton = {
        $0.setImage(UIImage(named: "uploadImage"), for: .normal)
        $0.addTarget(self, action: #selector(imageButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let uploadButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: "사진 올리기", attributes: textAttributes)
        let combinedString = NSMutableAttributedString()
        combinedString.append(attributedString)
        $0.titleLabel?.numberOfLines = 0
        $0.titleLabel?.textAlignment = .left
        $0.setAttributedTitle(combinedString, for: .normal)
        
        $0.setImage(UIImage(named: "blueBoard"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 33)
        $0.layer.cornerRadius = 20
        $0.backgroundColor = UIColor.white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.isSelected = false
        $0.addTarget(self, action: #selector(uploadButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.library.defaultMultipleSelection = true // 한장 선택 default (여러장 선택 O)
        config.library.maxNumberOfItems = 3
        config.library.preselectedItems = self.selectedImage
        config.wordings.libraryTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        config.wordings.cancel = "취소"
        config.wordings.next = "완료"
        config.colors.tintColor = .black
        return config
    }()
    
    weak var delegate: RestoreAlertControllerProtocol?
    
    //MARK: - Life Cycles
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    //MARK: - set UI
    private func setUI() {
        view.backgroundColor = .clear
        view.addSubview(backgroudView)
        backgroudView.addSubview(containerView)
        containerView.addSubview(dismissButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(phoneImageButton)
        containerView.addSubview(uploadButton)
        
        
        backgroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(300)
        }
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.left.equalToSuperview().inset(20)
        }
        phoneImageButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(135)
        }
        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(phoneImageButton.snp.bottom).inset(-30)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
    }
    
    //MARK: - Functions
    func presentAlbum() {
        let picker = YPImagePicker(configuration: self.config)
        picker.didFinishPicking { [ weak self, unowned picker] items, cancelled in
            self?.selectedProfileImages = []
            
            if cancelled {
                // 취소 눌렀을때
                picker.dismiss(animated: true)
            } else {
                // 사진 선택후
                for item in items {
                    switch item {
                    case .photo(p: let photo):
                        self?.selectedProfileImages.append(photo.image)
                    default:
                        print("DEBUG: 사진을 선택하지 않음")
                    }
                }
            }
            self?.selectedImage = items
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Selector
    @objc func dismissTap() {
        self.dismiss(animated: true)
    }
    
    @objc func imageButtonTap() {
        self.presentAlbum()
    }
    
    @objc func uploadButtonTap() {
        // 이미지 버튼 Tap Delgate 연결해야함
        self.delegate?.uploadImage(images: self.selectedProfileImages)
    }
}
