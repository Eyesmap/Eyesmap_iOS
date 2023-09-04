//
//  ProfileViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/12.
//

import UIKit
import SnapKit
import BetterSegmentedControl
import SDWebImage

class ProfileViewController: UIViewController {
    
    var profileModel: GetProfileResultData? {
        didSet {
            configure()
        }
    }
    
// MARK: - Properties
    private let profileLabel: UILabel = {
        $0.text = "프로필"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let modifyButton: UIButton = {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.addTarget(self, action: #selector(modifyButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())

    private let imageLabel: UILabel = {
        $0.text = "이미지"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let imageValueImageView: UIImageView = {
        $0.image = UIImage(named: "defaultProfile")
        $0.layer.cornerRadius = 46 / 2
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let imageButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(modifyButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let firstSepLine: UIView = {
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())
    
    private let nickNameLabel: UILabel = {
        $0.text = "닉네임"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let nickNameValueLabel: UILabel = {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let nickNameButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(modifyButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let secondSepLine: UIView = {
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())

    private let thirdSepLine: UIView = {
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())
    
    var currentPage: Int = 0 {
        didSet {
            configurePage(previousPage: oldValue, currentPage: currentPage)
        }
    }
    
    private lazy var resultTypeSegmentControl: BetterSegmentedControl = {
        let icons = [UIImage(named: "reportBtn")!, UIImage(named: "sympathyBtn")!]
        
        let imgSeg = IconSegment.segments(withIcons: icons,
                                          iconSize: CGSize(width: 55, height: 55),
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
        getProfileRequest()
        configureNavBar()
        setupPageViewController()
    }
    
//MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(profileLabel)
        view.addSubview(modifyButton)
        view.addSubview(imageLabel)
        view.addSubview(imageValueImageView)
        view.addSubview(imageButton)
        view.addSubview(firstSepLine)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameValueLabel)
        view.addSubview(nickNameButton)
        view.addSubview(secondSepLine)
        view.addSubview(resultTypeSegmentControl)
        view.addSubview(thirdSepLine)
        
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.equalToSuperview().inset(20)
        }
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(25)
            make.height.equalTo(15)
        }
        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).inset(-40)
            make.leading.equalToSuperview().inset(20)
        }
        imageButton.snp.makeConstraints { make in
            make.centerY.equalTo(imageLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(10)
            make.height.equalTo(14)
        }
        imageValueImageView.snp.makeConstraints { make in
            make.bottom.equalTo(imageLabel.snp.bottom)
            make.trailing.equalTo(imageButton.snp.leading).inset(-17)
            make.width.height.equalTo(46)
        }
        firstSepLine.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.8)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstSepLine.snp.bottom).inset(-15)
            make.leading.equalToSuperview().inset(20)
        }
        nickNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(10)
            make.height.equalTo(14)
        }
        nickNameValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nickNameLabel.snp.centerY)
            make.trailing.equalTo(nickNameButton.snp.leading).inset(-17)
        }
        secondSepLine.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.8)
        }
        resultTypeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(secondSepLine.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        thirdSepLine.snp.makeConstraints { make in
            make.top.equalTo(resultTypeSegmentControl.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0.8)
        }
        
        // PAGE VC
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(thirdSepLine.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func configureNavBar() {
        navigationItem.title = "MY"
        let settingImage = UIImage(systemName: "gearshape.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let setting = UIBarButtonItem(image: settingImage, style: .done, target: self, action: #selector(settingBtnTap))
        navigationItem.rightBarButtonItem = setting
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
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
    
//MARK: - API
    private func getProfileRequest() {
        ProfileNetworkManager.shared.getProfileRequest { [weak self] (error, model) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                self?.profileModel = model.result
            }
        }
    }
    
//MARK: - Configure
    private func configure() {
        guard let profileModel = profileModel else { return }
        
        let url = URL(string:"\(profileModel.profileImageUrl)")
        imageValueImageView.sd_setImage(with:url, completed: nil)
        nickNameValueLabel.text = profileModel.nickname
    }
    
//MARK: - Handler
    @objc func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        currentPage = sender.index
    }
    
    @objc func settingBtnTap() {
        let setVC = SettingViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    
    @objc func modifyButtonTap() {
        guard let image = imageValueImageView.image else { return }
        let modifyVC = ModifyProfileViewController(image: image)
        modifyVC.delegate = self
        self.navigationController?.pushViewController(modifyVC, animated: true)
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

//MARK: - ModifyProfileViewControllerDelegate
extension ProfileViewController: ModifyProfileViewControllerDelegate {
    // 프로필 수정 뷰에서 나오면
    func dismissView() {
        getProfileRequest()
        reportResultController.getReportRequest()
        sympathyResultController.getSympathyRequest()
    }
}
