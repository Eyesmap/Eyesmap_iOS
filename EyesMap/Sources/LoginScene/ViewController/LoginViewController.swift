//
//  LoginViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/21.
//

import UIKit
import SnapKit
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class LoginViewController: UIViewController {
//MARK: - Properties
    private let mainLogoImageView: UIImageView = {
        $0.image = UIImage(named: "mainLogo")
        return $0
    }(UIImageView())
    
    private let mainTitleLabel: UILabel = {
        $0.text = "아이즈맵"
        $0.font = UIFont.boldSystemFont(ofSize: 23)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.text = "간편하게 로그인하고\n아이즈맵 서비스를 이용해보세요"
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let kakaoButton: UIButton = {
        $0.setImage(UIImage(named: "kakao"), for: .normal)
        $0.addTarget(self, action: #selector(kakaoTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
//MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    

//MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(mainLogoImageView)
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(kakaoButton)
        
        mainLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(105)
        }
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLogoImageView.snp.bottom).inset(-7)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).inset(-20)
            make.centerX.equalToSuperview()
        }
        kakaoButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-50)
            make.leading.trailing.equalToSuperview().inset(35)
            make.height.equalTo(60)
        }
    }
    
//MARK: - Selector
    @objc func kakaoTap() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            loginWithApp()
        } else {
            loginWithWeb()
        }
    }
    
    func loginWithWeb() {
        // 유저 정보
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            // Validation
            if let error = error {
                print(error)
                return
            }
            
            UserApi.shared.me() { [weak self] (user, error) in
                // Validation
                if let error = error {
                    print(error)
                    return
                }
                
                guard let self = self,
                      let userId = user?.id else { return }
                
                self.kakaoLoginRequest(userId: Int(userId)) { model in
                    
                }
            }
        }
    }
    
    func loginWithApp() {
        // 유저 정보
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            // Validation
            if let error = error {
                print(error)
                return
            }
            
            UserApi.shared.me() { [weak self] (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let self = self,
                      let userId = user?.id else { return }
                
                self.kakaoLoginRequest(userId: Int(userId)) { model in
                    
                }
            }
        }
    }
    
//MARK: - Network
    func kakaoLoginRequest(userId: Int, completion: @escaping (LoginResultModel) -> Void) {
        AuthNetworkManager.shared.loginRequest(userId: userId) { model in
            let accessToken = model.result.accessToken
            let refreshToken = model.result.refreshToken
            
            print("accessToken = \(accessToken)")
            print("refreshToken = \(refreshToken)")
            completion(model)
        }
    }
    
}
