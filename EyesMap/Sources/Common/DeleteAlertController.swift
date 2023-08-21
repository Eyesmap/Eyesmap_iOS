//
//  DeleteAlertController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import SnapKit

protocol DeletedAlertControllerProtocol: AnyObject {
    func deleted(type: DeleteType)
}

enum DeleteType: CaseIterable {
    case restore
    case falseReport
    case duplicate
}

class DeletedAlertController: UIViewController {
    
    var isReasonButtonTaped = false
    var deleteType: DeleteType? = nil // 초기값
    
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
        $0.text = "삭제를 요청하시는\n이유가 궁금해요"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.text = "5건 이상의 삭제 요청이 들어오면 자동삭제 됩니다."
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textColor = .systemGray2
        return $0
    }(UILabel())
    
    private let restoreButton: DeleteRequestButton = {
        let btn = DeleteRequestButton(frame: .zero, text: "복구 완료 되었어요")
        btn.addTarget(self, action: #selector(reasonButtonTap), for: .touchUpInside)
        return btn
    }()
    
    private let falseReportButton: DeleteRequestButton = {
        let btn = DeleteRequestButton(frame: .zero, text: "허위 신고가 요청된 것 같아요")
        btn.addTarget(self, action: #selector(reasonButtonTap), for: .touchUpInside)
        return btn
    }()
    
    private let duplicatedButton: DeleteRequestButton = {
        let btn = DeleteRequestButton(frame: .zero, text: "중복 신고 된 것 같아요")
        btn.addTarget(self, action: #selector(reasonButtonTap), for: .touchUpInside)
        return btn
    }()

    private let deleteRequestButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: "삭제 요청하기", attributes: textAttributes)
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(reasonButtonTap), for: .touchUpInside)
        $0.isEnabled = false
        return $0
    }(UIButton())
    
    weak var delegate: DeletedAlertControllerProtocol?
    
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
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(restoreButton)
        containerView.addSubview(falseReportButton)
        containerView.addSubview(duplicatedButton)
        containerView.addSubview(deleteRequestButton)
        
        
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
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(20)
        }
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(37)
        }
        falseReportButton.snp.makeConstraints { make in
            make.top.equalTo(restoreButton.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(37)
        }
        duplicatedButton.snp.makeConstraints { make in
            make.top.equalTo(falseReportButton.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(37)
        }
        deleteRequestButton.snp.makeConstraints { make in
            make.top.equalTo(duplicatedButton.snp.bottom).inset(-14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
//MARK: - Selector
    @objc func dismissTap() {
        self.dismiss(animated: true)
    }
    
    @objc func reasonButtonTap(_ sender: UIButton) {
        if sender == restoreButton {
            if isReasonButtonTaped == false {
                sender.isSelected = true
                sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                sender.setTitleColor(.white, for: .normal)
                isReasonButtonTaped = true
                deleteType = .restore
                sender.backgroundColor = UIColor.alertDeleteButton
            } else {
                if falseReportButton.isSelected == true || duplicatedButton.isSelected == true {
                    falseReportButton.isSelected = false
                    duplicatedButton.isSelected = false
                    falseReportButton.setTitleColor(.lightGray, for: .normal)
                    duplicatedButton.setTitleColor(.lightGray, for: .normal)
                    falseReportButton.layer.borderColor = UIColor.systemGray4.cgColor
                    duplicatedButton.layer.borderColor = UIColor.systemGray4.cgColor
                    falseReportButton.backgroundColor = UIColor.white
                    duplicatedButton.backgroundColor = UIColor.white
                    deleteType = .restore
                    sender.isSelected = true
                    sender.setTitleColor(.white, for: .normal)
                    sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                    sender.backgroundColor = UIColor.alertDeleteButton
                } else {
                    sender.isSelected = false
                    sender.setTitleColor(.lightGray, for: .normal)
                    sender.layer.borderColor = UIColor.systemGray4.cgColor
                    isReasonButtonTaped = false
                    deleteType = nil
                    sender.backgroundColor = UIColor.white
                }
            }
        } else if sender == falseReportButton {
            if isReasonButtonTaped == false {
                sender.isSelected = true
                sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                sender.setTitleColor(.white, for: .normal)
                isReasonButtonTaped = true
                deleteType = .falseReport
                sender.backgroundColor = UIColor.alertDeleteButton

            } else {
                if restoreButton.isSelected == true || duplicatedButton.isSelected == true {
                    restoreButton.isSelected = false
                    duplicatedButton.isSelected = false
                    restoreButton.setTitleColor(.lightGray, for: .normal)
                    duplicatedButton.setTitleColor(.lightGray, for: .normal)
                    restoreButton.layer.borderColor = UIColor.systemGray4.cgColor
                    duplicatedButton.layer.borderColor = UIColor.systemGray4.cgColor
                    restoreButton.backgroundColor = UIColor.white
                    duplicatedButton.backgroundColor = UIColor.white
                    deleteType = .falseReport
                    sender.isSelected = true
                    sender.setTitleColor(.white, for: .normal)
                    sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                    sender.backgroundColor = UIColor.alertDeleteButton
                } else {
                    sender.isSelected = false
                    sender.setTitleColor(.lightGray, for: .normal)
                    sender.layer.borderColor = UIColor.systemGray4.cgColor
                    isReasonButtonTaped = false
                    deleteType = nil
                    sender.backgroundColor = UIColor.white
                }
            }
        } else if sender == duplicatedButton {
            if isReasonButtonTaped == false {
                sender.isSelected = true
                sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                sender.setTitleColor(.white, for: .normal)
                isReasonButtonTaped = true
                deleteType = .duplicate
                sender.backgroundColor = UIColor.alertDeleteButton
                
            } else {
                if restoreButton.isSelected == true || falseReportButton.isSelected == true {
                    restoreButton.isSelected = false
                    falseReportButton.isSelected = false
                    restoreButton.setTitleColor(.lightGray, for: .normal)
                    falseReportButton.setTitleColor(.lightGray, for: .normal)
                    restoreButton.layer.borderColor = UIColor.systemGray4.cgColor
                    falseReportButton.layer.borderColor = UIColor.systemGray4.cgColor
                    restoreButton.backgroundColor = UIColor.white
                    falseReportButton.backgroundColor = UIColor.white
                    deleteType = .duplicate
                    sender.isSelected = true
                    sender.setTitleColor(.white, for: .normal)
                    sender.layer.borderColor = UIColor.alertDeleteButton.cgColor
                    sender.backgroundColor = UIColor.alertDeleteButton
                } else {
                    sender.isSelected = false
                    sender.setTitleColor(.lightGray, for: .normal)
                    sender.layer.borderColor = UIColor.systemGray4.cgColor
                    isReasonButtonTaped = false
                    deleteType = nil
                    sender.backgroundColor = UIColor.white
                }
                
            }
        } else if sender == deleteRequestButton {
            //신고 API 연결
            switch deleteType {
            case .restore:
                self.dismiss(animated: true) {
                    print("dismiss")
                    self.delegate?.deleted(type: .restore)
                }
            case .falseReport:
                self.dismiss(animated: true) {
                    print("dismiss")
                    self.delegate?.deleted(type: .falseReport)
                }
            case .duplicate:
                self.dismiss(animated: true) {
                    print("dismiss")
                    self.delegate?.deleted(type: .duplicate)
                }
            default:
                return
            }
        }
        
        if isReasonButtonTaped == true {
            deleteRequestButton.isEnabled = true
            deleteRequestButton.backgroundColor = UIColor.black
        } else {
            deleteRequestButton.isEnabled = false
            deleteRequestButton.backgroundColor = UIColor.systemGray4
        }
        
    }
}
