//
//  ReportViewController.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/14.
//

import UIKit
import CoreLocation
import SnapKit
import YPImagePicker
import FloatingPanel

var checkBox_dis = false

class ReportViewController: UIViewController, UITextDragDelegate, UITextViewDelegate {
    
    //MARK: - properties
    private var selectedImages: [UIImage] = [] // 이미지 저장
    private var titleValue = ""
    private var damagedStatus = ""
    
    private let scrollView = UIScrollView()
    let contentView = UIView()
    let imagePickerView = UIImageView()

    private let reportLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 위치"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()
    
    private lazy var locationTextfield: UITextField = {
        let input = UITextField()
        input.addLeftPadding()
        input.text = self.reportAddress
        input.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        
        input.layer.cornerRadius = 11
        input.layer.borderWidth = 1.0
        input.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        
        return input
    }()
    
    private let reportTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 제목"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()
    
    private let titleTextfield: UITextField = {
        let input = UITextField()
        input.addLeftPadding()
        
        input.placeholder = "인도 보도블럭 파손"
        //        input.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        
        input.layer.cornerRadius = 11
        input.layer.borderWidth = 1.0
        input.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        
        return input
    }()
    
    private let reportCategory: UILabel = {
        let label = UILabel()
        label.text = "신고 분류"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()
    
    // 신고 분류 스크롤뷰 넣을 자리
    private let checkBox1: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category1: UILabel = {
        let label = UILabel()
        label.text = "점자블록"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    private let checkBox2: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category2: UILabel = {
        let label = UILabel()
        label.text = "음향유도장치"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    private let checkBox2_1: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category2_1: UILabel = {
        let label = UILabel()
        label.text = "점자안내판"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    private let facilityState: UILabel = {
        let label = UILabel()
        label.text = "시설물 손상 상태"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()
    private let checkBox3: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category3: UILabel = {
        let label = UILabel()
        label.text = "보통"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    private let checkBox4: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category4: UILabel = {
        let label = UILabel()
        label.text = "나쁨"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    private let checkBox5: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "check_fill"), for: .selected)
        btn.setImage(UIImage(named: "check"), for: .normal)
        return btn
    }()
    private let category5: UILabel = {
        let label = UILabel()
        label.text = "심각"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        return label
    }()
    // 시설물 상태 스크롤뷰 넣을 자리
    
    private let setImageLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 첨부"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()
    
    private lazy var  attachImageButton: UIButton = {
        let button = UIButton()
        let galleryImageView = UIImageView(image: UIImage(named: "gallery-add"))
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 0.2).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10

        button.addSubview(galleryImageView)
       
        galleryImageView.layer.opacity = 0.5
        galleryImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           galleryImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
           galleryImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
           galleryImageView.widthAnchor.constraint(equalToConstant: 24),
           galleryImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        return button
    }()

    // 사진 첨부하기 버튼 넣을 자리
    
    private let reportDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "신고 내용 (선택)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        return label
    }()

    private let detailTextView: UITextView = {
        let detail = UITextView()
        detail.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10);
        detail.layer.cornerRadius = 11
        detail.layer.borderWidth = 1.0
        detail.text = "불편 신고 내용을 입력해주세요"
        detail.font = UIFont.systemFont(ofSize: 14)
        detail.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        detail.layer.borderColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        return detail
    }()

    private let submitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("신고 완료하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        btn.isEnabled = false
        btn.layer.cornerRadius = 20
//        btn.setTitleColor(UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1), for: .normal)
//        btn.setTitleColor(UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1), for: .highlighted)
        return btn
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
    //    layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 6.0
        layout.itemSize = CGSize(width: 109, height: 109)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        //    view.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(ReportImageCollectionViewCell.self, forCellWithReuseIdentifier: ReportImageCollectionViewCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 컬랙션뷰를 감쌀 view
    private let containerCollectionView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.library.defaultMultipleSelection = true // 한장 선택 default (여러장 선택 O)
        config.library.maxNumberOfItems = 6
//        config.library.preselectedItems = self.selectedImages
        config.wordings.libraryTitle = "앨범"
        config.wordings.cameraTitle = "카메라"
        config.wordings.cancel = "취소"
        config.wordings.next = "완료"
        config.colors.tintColor = .black
        return config
    }()
    
    private lazy var fpc: FloatingPanelController = {
        let controller = FloatingPanelController(delegate: self)
        controller.changePanelStyle()
        controller.layout = ReportFloatingPanelLayout()
        return controller
    }()
    
    private let reportPosition: CLLocation
    private let reportAddress: String

//MARK: - Life Cycles
    init(position: CLLocation, address: String) {
        self.reportPosition = position
        self.reportAddress = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "신고하기"
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
//        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")

        detailTextView.delegate = self
        locationTextfield.delegate = self
        titleTextfield.delegate = self
        view.addSubview(scrollView)
        
        
        
        
        /* 컬랙션 뷰를 감살 컨테이너 정의*/
        contentView.addSubview(containerCollectionView)
        
        
        
        /* 컬랙션 뷰 설정 */
        
        containerCollectionView.addSubview(collectionView)
//        containerCollectionView.topAnchor.constraint(equalTo: attachImageButton.bottomAnchor, constant: 20)
//        containerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
//        containerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        NSLayoutConstraint.activate([
            
            collectionView.leadingAnchor.constraint(equalTo: containerCollectionView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerCollectionView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: containerCollectionView.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 109),
        ])




        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .white
        contentView.addSubview(reportLocationLabel)
        contentView.addSubview(locationTextfield)
        contentView.addSubview(reportTitleLabel)
        contentView.addSubview(titleTextfield)
        contentView.addSubview(reportCategory)
        contentView.addSubview(facilityState)
        contentView.addSubview(checkBox1)
        contentView.addSubview(category1)
        contentView.addSubview(checkBox2)
        contentView.addSubview(category2)
        contentView.addSubview(checkBox2_1)
        contentView.addSubview(category2_1)
        contentView.addSubview(checkBox3)
        contentView.addSubview(category3)
        contentView.addSubview(checkBox4)
        contentView.addSubview(category4)
        contentView.addSubview(checkBox5)
        contentView.addSubview(category5)
        contentView.addSubview(setImageLabel)
        contentView.addSubview(attachImageButton)
        contentView.addSubview(reportDetailLabel)
        contentView.addSubview(detailTextView)
        contentView.addSubview(submitBtn)
        scrollView.addSubview(contentView)
        
        
        // -----
//        contentView.addSubview(imageCollectionView)
//        imageCollectionView.snp.makeConstraints { (make) in
//            make.top.equalTo(attachImageButton.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(100)
//        }
        //------
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(860)
        }

        reportLocationLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(contentView.snp.top).inset(20)
        }
        locationTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(reportLocationLabel.snp.bottom).offset(26)
            make.leading.equalTo(reportLocationLabel.snp.leading)
            make.height.equalTo(46)
            make.width.equalTo(335)
        }
        reportTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(locationTextfield.snp.bottom).offset(42)
            make.leading.equalTo(reportLocationLabel.snp.leading)
        }
        titleTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(reportTitleLabel.snp.bottom).offset(26)
            make.leading.equalTo(reportLocationLabel.snp.leading)
            make.height.equalTo(46)
            make.width.equalTo(335)
        }
        reportCategory.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextfield.snp.bottom).offset(42)
            make.leading.equalTo(reportLocationLabel.snp.leading)
        }
        checkBox1.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(26)
            make.leading.equalTo(reportLocationLabel.snp.leading)
        }
        category1.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(29)
            make.leading.equalTo(checkBox1.snp.trailing).offset(10)
        }
        checkBox2.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(26)
            make.leading.equalTo(category1.snp.trailing).offset(20)
        }
        category2.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(29)
            make.leading.equalTo(checkBox2.snp.trailing).offset(10)
        }
        checkBox2_1.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(26)
            make.leading.equalTo(category2.snp.trailing).offset(20)
        }
        category2_1.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(29)
            make.leading.equalTo(checkBox2_1.snp.trailing).offset(10)
        }
        // 스크롤뷰 넣을 자리
        facilityState.snp.makeConstraints { (make) in
            make.top.equalTo(reportCategory.snp.bottom).offset(76)
            make.leading.equalTo(reportLocationLabel.snp.leading)
        }
        checkBox3.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(26)
            make.leading.equalTo(facilityState.snp.leading)
        }
        category3.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(29)
            make.leading.equalTo(checkBox1.snp.trailing).offset(10)
        }
        checkBox4.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(26)
            make.leading.equalTo(category3.snp.trailing).offset(50)
        }
        category4.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(29)
            make.leading.equalTo(checkBox4.snp.trailing).offset(10)
        }
        checkBox5.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(26)
            make.leading.equalTo(category4.snp.trailing).offset(50)
        }
        category5.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(29)
            make.leading.equalTo(checkBox5.snp.trailing).offset(10)
        }
        setImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(facilityState.snp.bottom).offset(77)
            make.leading.equalTo(facilityState.snp.leading)
        }
        
        attachImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(setImageLabel.snp.bottom).offset(26)
            make.leading.equalTo(setImageLabel.snp.leading)
            make.width.equalTo(109)
            make.height.equalTo(109)
        }
        containerCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(attachImageButton.snp.top)
            make.leading.equalTo(attachImageButton.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(attachImageButton.snp.bottom)
        }
        
        // 사진 첨부 버튼 넣을 자리
        reportDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setImageLabel.snp.bottom).offset(161)
            make.leading.equalTo(setImageLabel.snp.leading)
        }
        
        detailTextView.snp.makeConstraints { (make) in
            make.width.equalTo(335)
            make.height.equalTo(92)
            make.top.equalTo(reportDetailLabel.snp.bottom).offset(26)
            make.leading.equalTo(reportDetailLabel.snp.leading)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.width.equalTo(337)
            make.height.equalTo(46)
            make.top.equalTo(detailTextView.snp.bottom).offset(26)
            make.leading.equalTo(detailTextView.snp.leading)
            make.bottom.equalTo(contentView.snp.bottom).inset(5)
        }
        
        addTarget()
    }
    private func addTarget() {
        checkBox1.addTarget(self, action: #selector(Check1), for: .touchUpInside)
        checkBox2.addTarget(self, action: #selector(Check2), for: .touchUpInside)
        checkBox2_1.addTarget(self, action: #selector(Check2_1), for: .touchUpInside)
        checkBox3.addTarget(self, action: #selector(Check3), for: .touchUpInside)
        checkBox4.addTarget(self, action: #selector(Check4), for: .touchUpInside)
        checkBox5.addTarget(self, action: #selector(Check5), for: .touchUpInside)
        submitBtn.addTarget(self, action: #selector(Submit), for: .touchUpInside)
        attachImageButton.addTarget(self, action: #selector(attachImage), for: .touchUpInside)

        
    }
    @objc func Check1() {
        if(checkBox1.isSelected) {
            titleValue = ""
            checkBox1.isSelected = false
            checkBox_dis = false
            category1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            titleValue = SortType.dottedBlock.rawValue
            checkBox_dis = true
            checkBox1.isSelected = true
            checkBox2.isSelected = false
            category2.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            checkBox2_1.isSelected = false
            category2_1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category1.textColor = .black
        }
        CheckSubmitBtn()
    }
    @objc func Check2() {
        if(checkBox2.isSelected) {
            titleValue = ""
            checkBox2.isSelected = false
            checkBox_dis = false
            category2.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            titleValue = SortType.acousticGuidenceSystem.rawValue
            checkBox_dis = true
            checkBox2.isSelected = true
            checkBox1.isSelected = false
            category1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            checkBox2_1.isSelected = false
            category2_1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category2.textColor = .black
        }
        CheckSubmitBtn()
    }
    @objc func Check2_1() {
        if(checkBox2_1.isSelected) {
            titleValue = ""
            checkBox2_1.isSelected = false
            checkBox_dis = false
            category2_1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            titleValue = SortType.brailleInfoBoard.rawValue
            checkBox_dis = true
            checkBox2_1.isSelected = true
            checkBox1.isSelected = false
            category1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            checkBox2.isSelected = false
            category2.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category2_1.textColor = .black
        }
        CheckSubmitBtn()
    }
    @objc func Check3() {
        if(checkBox3.isSelected) {
            damagedStatus = ""
            checkBox3.isSelected = false
            checkBox_dis = false
            category3.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            damagedStatus = DamageStatusType.normal.rawValue
            checkBox_dis = true
            checkBox3.isSelected = true
            checkBox4.isSelected = false
            checkBox5.isSelected = false
            category3.textColor = .black
            category4.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category5.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        }
        CheckSubmitBtn()
    }
    @objc func Check4() {
        if(checkBox4.isSelected) {
            damagedStatus = ""
            checkBox4.isSelected = false
            checkBox_dis = false
            category4.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            damagedStatus = DamageStatusType.bad.rawValue
            checkBox_dis = true
            checkBox4.isSelected = true
            checkBox3.isSelected = false
            checkBox5.isSelected = false
            category4.textColor = .black
            category3.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category5.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        }
        CheckSubmitBtn()
    }
    @objc func Check5() {
        if(checkBox5.isSelected) {
            damagedStatus = ""
            checkBox5.isSelected = false
            checkBox_dis = false
            category5.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
            damagedStatus = DamageStatusType.severe.rawValue
            checkBox_dis = true
            checkBox3.isSelected = false
            checkBox4.isSelected = false
            checkBox5.isSelected = true
            category5.textColor = .black
            category3.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            category4.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        }
        CheckSubmitBtn()
    }
    @objc private func attachImage() {
        let picker = YPImagePicker(configuration: self.config)
        picker.didFinishPicking { [ weak self, unowned picker] items, cancelled in
            self?.selectedImages = []
            
            if cancelled {
                // 취소 눌렀을때
                picker.dismiss(animated: true)
            } else {
                // 사진 선택후
                for item in items {
                    switch item {
                    case .photo(p: let photo):
                        self?.selectedImages.append(photo.image)
                        
                        DispatchQueue.main.async {
                            guard let imgCnt = self?.selectedImages.count else { return }
                            let colorText = "사진 첨부  \(imgCnt) / 5"
                            if(imgCnt == 0) {
                                self?.setImageLabel.text = colorText
                            } else {
                                let attributedString = NSMutableAttributedString(string: colorText)
                                let range = (colorText as NSString).range(of: String(imgCnt))
                                attributedString.addAttribute(.foregroundColor, value: UIColor(red: 221/255, green: 112/255, blue: 97/255, alpha: 1), range: range)
                                self?.setImageLabel.attributedText = attributedString
                                
                            }
                            
                            self?.CheckSubmitBtn()
                        }
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    default:
                        print("DEBUG: 사진을 선택하지 않음")
                    }
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func Submit() {
        print("submit")
        let model = CreateComplaintRequestModel(address: reportAddress,
                                                gpsX: reportPosition.coordinate.longitude,
                                                gpsY: reportPosition.coordinate.latitude,
                                                title: titleTextfield.text ?? "",
                                                contents: detailTextView.text ?? "",
                                                damagedStatus: damagedStatus, // DamagedStatusType
                                                sort: titleValue) // SortType
        
        ReportNetworkManager.shared.createComplaintRequest(images: selectedImages, parameters: model) { [weak self] b in
            b ? self?.presentFinishedView() : self?.dismiss(animated: true)
        }
    }

    func CheckSubmitBtn() {
        if !checkBox1.isSelected && !checkBox2.isSelected && !checkBox2_1.isSelected {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        if !checkBox3.isSelected && !checkBox4.isSelected && !checkBox5.isSelected {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        if locationTextfield.text!.count == 0 || titleTextfield.text!.count == 0 {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        if selectedImages.count == 0 {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        print(titleTextfield.text!.count)
        submitBtn.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
        submitBtn.isEnabled = true
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detailTextView.text.isEmpty {
            detailTextView.text = "불편 신고 내용을 입력해주세요"
            detailTextView.textColor =  UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailTextView.textColor == UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1) {
            detailTextView.text = nil
            detailTextView.textColor = .black
        }
    }
    
    func presentFinishedView() {
        let bv: UIView = {
            $0.backgroundColor = .black.withAlphaComponent(0.4)
            return $0
        }(UIView())

        view.addSubview(bv)
        bv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let reportVC = FinishedFloatingController(type: .report)
        reportVC.delegate = self
        fpc.set(contentViewController: reportVC)
        fpc.track(scrollView: reportVC.scrollView)
        self.present(fpc, animated: true)
    }
}

extension ReportViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportImageCollectionViewCell.identifier, for: indexPath) as? ReportImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.image = self.selectedImages[indexPath.item]
        cell.deleteBtn.tag = indexPath.item

        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap(sender:)), for: .touchUpInside)
        return cell
    }

    @objc func deleteBtnTap(sender: UIButton) {
        if sender.tag < selectedImages.count {
            self.selectedImages.remove(at: sender.tag)
            let imgCnt = selectedImages.count
            let colorText = "사진 첨부  \(imgCnt) / 5"
            if(imgCnt == 0) {
                setImageLabel.text = colorText
            } else {
                let attributedString = NSMutableAttributedString(string: colorText)
                let range = (colorText as NSString).range(of: String(imgCnt))
                attributedString.addAttribute(.foregroundColor, value: UIColor(red: 221/255, green: 112/255, blue: 97/255, alpha: 1), range: range)
                setImageLabel.attributedText = attributedString
                
            }

            self.collectionView.reloadData()
        }
    }
}

extension ReportViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        CheckSubmitBtn()
    }
}

extension ReportViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
        if fpc.state == .half {
            
        } else {
            fpc.move(to: .half, animated: true)
        }
    }
}

extension ReportViewController: FinishedFloatingControllerDelegate {
    func dismiss() {
        if let iv = view.subviews.last {
            iv.removeFromSuperview()
            self.dismiss(animated: true)
        }
    }
}
