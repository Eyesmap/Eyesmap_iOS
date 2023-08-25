//
//  ReportViewController.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/14.
//

import UIKit
import SnapKit
import PhotosUI

var checkBox_dis = false

class ReportViewController: UIViewController, UITextDragDelegate, UITextViewDelegate {
    
    //MARK: - properties
    var selectedImages: [UIImage] = [] // 이미지 저장

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
    
    private let locationTextfield: UITextField = {
        let input = UITextField()
        input.addLeftPadding()
        input.text = "서울특별시 용산구 동자동 43-209"
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
    
    private let TitleTextfield: UITextField = {
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
        button.setTitle("사진 첨부하기 0/6", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1).cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10

        button.addSubview(galleryImageView)
       
        galleryImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           galleryImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 95),
           galleryImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
           galleryImageView.widthAnchor.constraint(equalToConstant: 15),
           galleryImageView.heightAnchor.constraint(equalToConstant: 15)
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
        layout.minimumInteritemSpacing = 8.0
        layout.itemSize = CGSize(width: 100, height: 100)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
//        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")

        detailTextView.delegate = self
        locationTextfield.delegate = self
        TitleTextfield.delegate = self
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
            collectionView.heightAnchor.constraint(equalToConstant: 100),
        ])




        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .white
        contentView.addSubview(reportLocationLabel)
        contentView.addSubview(locationTextfield)
        contentView.addSubview(reportTitleLabel)
        contentView.addSubview(TitleTextfield)
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
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // == make.edges.equalTo(0)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1000)
        }

        reportLocationLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
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
        TitleTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(reportTitleLabel.snp.bottom).offset(26)
            make.leading.equalTo(reportLocationLabel.snp.leading)
            make.height.equalTo(46)
            make.width.equalTo(335)
        }
        reportCategory.snp.makeConstraints { (make) in
            make.top.equalTo(TitleTextfield.snp.bottom).offset(42)
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
            make.top.equalTo(reportCategory.snp.bottom).offset(116)
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
            make.top.equalTo(facilityState.snp.bottom).offset(88)
            make.leading.equalTo(facilityState.snp.leading)
        }
        
        attachImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(setImageLabel.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(337)
            make.height.equalTo(46)
        }
        containerCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(attachImageButton.snp.bottom).offset(20)
            make.leading.equalTo(attachImageButton)
            make.trailing.equalTo(attachImageButton).offset(10)
            make.height.equalTo(125)
        }
        
        // 사진 첨부 버튼 넣을 자리
        reportDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setImageLabel.snp.bottom).offset(220)
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
            checkBox1.isSelected = false
            checkBox_dis = false
            category1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
            checkBox2.isSelected = false
            checkBox_dis = false
            category2.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
            checkBox2_1.isSelected = false
            checkBox_dis = false
            category2_1.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
            checkBox3.isSelected = false
            checkBox_dis = false
            category3.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
            checkBox4.isSelected = false
            checkBox_dis = false
            category4.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
            checkBox5.isSelected = false
            checkBox_dis = false
            category5.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        } else {
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
        var config = PHPickerConfiguration()
        config.filter = .images
        // 이미지 다시 선택 시 배열 초기화 작업
        selectedImages.removeSubrange(0..<selectedImages.count)
//        config.selection = .ordered
        config.selectionLimit = 6
        let imagePickerViewController = PHPickerViewController(configuration: config)
        imagePickerViewController.delegate = self
        present(imagePickerViewController, animated: true)
    }
    
    @objc func Submit() {
        print("submit")
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
        if locationTextfield.text!.count == 0 || TitleTextfield.text!.count == 0 {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        if selectedImages.count == 0 {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
            return
        }
        print(TitleTextfield.text!.count)
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
}

extension ReportViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReportImageCollectionViewCell.identifier, for: indexPath) as? ReportImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.image = self.selectedImages[indexPath.item]

        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap(sender:)), for: .touchUpInside)
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print(5)
//        return CGSize(width: 100, height: 100)
//    }
    @objc func deleteBtnTap(sender: UIButton) {
        self.collectionView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        self.selectedImages.remove(at: sender.tag)
        self.collectionView.reloadData()
        self.attachImageButton.setTitle("사진 첨부하기 \(self.selectedImages.count) / 6", for: .normal)
    }
}

extension ReportViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        
        if !results.isEmpty {
            
            results.forEach { result in
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                        guard let self = self else { return }
                        if let image = image as? UIImage {
                            self.selectedImages.append(image)
                            DispatchQueue.main.async {
                                //                                self.imagePickerView.image = image
                                self.attachImageButton.setTitle("사진 첨부하기 \(self.selectedImages.count) / 6", for: .normal)
                                print(self.selectedImages.count)
                                print(self.selectedImages)
                                self.CheckSubmitBtn()
                            }
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                        
                        if let error = error {
                            print("ERROR - UploadFeedViewController - PHPickerViewControllerDelegate - \(error.localizedDescription)")
                        }
                        
                    }
                }
            }
            
        }
        print("results:", results)
        dismiss(animated: true)
        
    }
}

extension ReportViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        CheckSubmitBtn()
    }
}
