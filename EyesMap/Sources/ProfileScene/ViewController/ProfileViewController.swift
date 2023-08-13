//
//  ProfileViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/12.
//

import UIKit
import SnapKit
import BetterSegmentedControl

class ProfileViewController: UIViewController {
// MARK: - Properties
    private let profileLabel: UILabel = {
        $0.text = "프로필"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        return $0
    }(UILabel())

    private let nicknameView: ProfileInstanceView = {
        $0.titleLabel.text = "닉네임"
        $0.nickNameLabel.text = "01012345678"
        return $0
    }(ProfileInstanceView())
    
    private let sepLine: UIView = {
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())

    var currentPage: Int = 0 {
        didSet {
            configurePage(previousPage: oldValue, currentPage: currentPage)
        }
    }
    
    private lazy var resultTypeSegmentControl: BetterSegmentedControl = {
        let icons = [UIImage(named: "blueBoard")!, UIImage(named: "selectedDanger")!]
        
        let imgSeg = IconSegment.segments(withIcons: icons,
                                          iconSize: CGSize(width: 21, height: 21),
                                          normalBackgroundColor: .clear,
                                          normalIconTintColor: .systemGray3,
                                          selectedBackgroundColor: .clear,
                                          selectedIconTintColor: .black)
        
        let seg = BetterSegmentedControl(frame: .zero,
                                         segments: imgSeg,
                                         options: [.backgroundColor(.clear), .indicatorViewBackgroundColor(.white), .indicatorViewInset(0)])
        seg.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return seg
    }()
    
    lazy var reportResultController = ProfileCollectionViewController(resultType: .report)
    lazy var sympathyResultController = ProfileCollectionViewController(resultType: .sympathy)
    lazy var viewControllers = [reportResultController, sympathyResultController]
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return vc
    }()
    
// MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        configureNavBar()
        setupPageViewController()
    }
    
//MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileLabel)
        view.addSubview(nicknameView)
        view.addSubview(resultTypeSegmentControl)
        view.addSubview(sepLine)
        
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.equalToSuperview().inset(20)
        }
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        resultTypeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(nicknameView.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        sepLine.snp.makeConstraints { make in
            make.top.equalTo(resultTypeSegmentControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.8)
        }
        
        // PAGE VC
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(sepLine.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func configureNavBar() {
        navigationItem.title = "MY"
        let settingImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let setting = UIBarButtonItem.init(image: settingImage)
        navigationItem.rightBarButtonItem = setting
    }
    
//MARK: - Functionse
    private func configurePage(previousPage: Int, currentPage: Int) {
        let direction: UIPageViewController.NavigationDirection = previousPage < currentPage ? .forward : .reverse
        pageViewController.setViewControllers([viewControllers[currentPage]], direction: direction, animated: true)
        
        resultTypeSegmentControl.setIndex(currentPage)
    }
    
    private func setupPageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if let firstVC = viewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
//MARK: - Handler
    @objc func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        currentPage = sender.index
    }
}

//MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension ProfileViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ProfileCollectionViewController,
              let index = viewControllers.firstIndex(of: vc) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return viewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ProfileCollectionViewController,
              let index = viewControllers.firstIndex(of: vc) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewControllers.count {
            return nil
        }
        return viewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first as? ProfileCollectionViewController,
              let currentIndex = viewControllers.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
}
