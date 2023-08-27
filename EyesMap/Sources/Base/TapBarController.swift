//
//  TapBarController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/14.
//
import UIKit

class TabBarController: UITabBarController {
    //MARK: - Properties
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAuth()
    }
    

    
    //MARK: - Auth 상태에 따라 View 변경
    func configureAuth() {
        print("🔥ConfigureAuth")
        // 유저 토큰이 존재하면
//        if TokenManager.getUserAccessToken() != nil {
            print("🔥AccessToken = \(TokenManager.getUserAccessToken())")
            // ToDo - 액세스 토큰 유효 검사
//            configureViewControllers()
//        } else {
            // 로그인 뷰 띄우기
            configureViewControllers() //MARK: 임시
            presentAuthView()
//        }
    }
    
    //MARK: - 로그인 뷰 띄우기
    private func presentAuthView() {
        // 유저 토큰이 존재하지 않다면
        DispatchQueue.main.async { [weak self] in
            let loginView = LoginViewController()
            loginView.modalPresentationStyle = .fullScreen
            self?.present(loginView, animated: true)
        }
    }
    
    //MARK: - Function
    private func configureViewControllers() {
        tabBarSetting()
        // 첫번째 탭
        let firstVC = HomeViewController()
        let nav1 = templateNavigationController(UIImage(systemName: "house"), title: "홈", viewController: firstVC)
        
        // 두번째 탭
        let secondVC = LocationDataViewController()
        let nav2 = templateNavigationController(UIImage(systemName: "filemenu.and.cursorarrow"), title: "LIVE", viewController: secondVC)
        
        // 세번째 탭
        let thirdVC = UIViewController()
        let nav3 = templateNavigationController(UIImage(systemName: "trophy.fill"), title: "명예의 전당", viewController: thirdVC)
        
        let fourthVC = ProfileViewController()
        let nav4 = templateNavigationController(UIImage(systemName: "person.fill"), title: "MY", viewController: fourthVC)
        // 탭들 Setup
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    // 네비게이션 컨트롤러 만들기
    private func templateNavigationController(_ image: UIImage?, title: String, viewController: UIViewController) -> UINavigationController {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationItem.largeTitleDisplayMode = .automatic
        nav.navigationBar.tintColor = .black
        
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = image
        nav.tabBarItem.title = title
        
        return nav
    }
    
    func tabBarSetting() {
        if #available(iOS 14.0, *){
            tabBar.tintColor = UIColor.black
            tabBar.unselectedItemTintColor = .systemGray
            tabBar.backgroundColor = .white
            tabBar.barStyle = .default
            tabBar.layer.masksToBounds = false
            tabBar.isTranslucent = false
        }
    }
}
