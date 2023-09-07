//
//  SettingViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/14.
//

import UIKit
import SnapKit

protocol SettingViewControllerDelegate: AnyObject {
    func dismissSettingView()
}

class SettingViewController: UIViewController {
    
    weak var delegate: SettingViewControllerDelegate?
    
// MARK: - Properties
    private let titleLabel: UILabel = {
        $0.text = "음성안내 기능"
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let speakInfoLabel: UILabel = {
        $0.text = "음성 알림"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let detailInfoLabel: UILabel = {
        $0.text = "신고된 장소에 대해 이용자가 50 m 이내로 접근 시,\n파손, 미흡 공공시설이 가까이 있음을 음성으로 알림."
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let termsLabel: UILabel = {
        $0.text = "약관"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let useTermView: TermView = {
        $0.titleLabel.text = "이용약관"
        return $0
    }(TermView())
    
    let privateInfoTermView: TermView = {
        $0.titleLabel.text = "개인정보 처리방침"
        return $0
    }(TermView())
    
    let toggleButton: CustomToggleButton = {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        return $0
    }(CustomToggleButton(frame: CGRect(x: 0, y: 0, width: 60, height: 33)))
    
    private let accountLabel: UILabel = {
        $0.text = "카카오 계정 회원"
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let logOutButton: UIButton = {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.addTarget(self, action: #selector(logOutButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
// MARK: - Life Cycles
    init(isOn: Bool) {
        toggleButton.isOn = isOn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        functionSetting()
        setupNavigationBackBar()
    }
    
    func functionSetting() {
        toggleButton.delegate = self
        
        useTermView.imageButton.addTarget(self, action: #selector(useTermTap), for: .touchUpInside)
        privateInfoTermView.imageButton.addTarget(self, action: #selector(privateInfoTermTap), for: .touchUpInside)
    }
    
    func setupNavigationBackBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(dismissTap))
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

// MARK: - Set UI
    private func setUI() {
        title = "설정"
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(speakInfoLabel)
        view.addSubview(detailInfoLabel)
        view.addSubview(toggleButton)
        view.addSubview(termsLabel)
        view.addSubview(useTermView)
        view.addSubview(privateInfoTermView)
        view.addSubview(accountLabel)
        view.addSubview(logOutButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.leading.equalToSuperview().inset(20)
        }
        speakInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-40)
            make.leading.equalToSuperview().inset(20)
        }
        detailInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(speakInfoLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(20)
        }
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(speakInfoLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(33)
            make.width.equalTo(60)
        }
        termsLabel.snp.makeConstraints { make in
            make.top.equalTo(detailInfoLabel.snp.bottom).inset(-42)
            make.leading.equalToSuperview().inset(20)
        }
        useTermView.snp.makeConstraints { make in
            make.top.equalTo(termsLabel.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        privateInfoTermView.snp.makeConstraints { make in
            make.top.equalTo(useTermView.snp.bottom).inset(-18)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(privateInfoTermView.snp.bottom).inset(-42)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        logOutButton.snp.makeConstraints { make in
            make.centerY.equalTo(accountLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(29)
            make.height.equalTo(20)
        }
    }
    

// MARK: - Handler
    @objc private func logOutButtonTap() {
        let actionAlert = UIAlertController(title: "로그아웃", message: "정말로 로그아웃을 하시겠습니까?", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "로그아웃", style: .default) { _ in
            AuthNetworkManager.shared.logoutRequest { [weak self] model in
                DispatchQueue.main.async {
                    if let tabBarVC = self?.tabBarController as? TabBarController {
                        print("로그아웃에 \(model.message)")
                        tabBarVC.configureAuth()
                        tabBarVC.selectedIndex = 0
                        TokenManager.resetUserToken()
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionAlert.addAction(logout)
        actionAlert.addAction(cancel)
        
        present(actionAlert, animated: true)
    }
    
    @objc private func useTermTap() {
        let vc = WebViewController()
        vc.title = "개인정보처리방침"
        vc.url = URL(string: Secret.shared.serviceTerm)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func privateInfoTermTap() {
        let vc = WebViewController()
        vc.title = "이용약관"
        vc.url = URL(string: Secret.shared.privateInfoTerm)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func dismissTap() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.dismissSettingView()
    }
}

//MARK: - CustomToggleButtonDelegate
extension SettingViewController: CustomToggleButtonDelegate {
    func isOnValueChange(isOn: Bool) {
        print("toggleButton: \(isOn)")
    }
}
