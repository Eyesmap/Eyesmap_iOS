//
//  DetailViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/10.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation

class DetailViewController: UIViewController {
    
    private var complaint: ComplaintModel {
        didSet {
            configureMapView()
        }
    }
    
    var detailImageList = [
        UIImage(named: "block")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "block")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "block")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "block")?.withRenderingMode(.alwaysOriginal),
        UIImage(named: "block")?.withRenderingMode(.alwaysOriginal)
    ]
    
//MARK: - Properties
    private let backButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var scrollView: UIScrollView = {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.isScrollEnabled = true
        $0.contentSize = contentView.bounds.size
        return $0
    }(UIScrollView())
    
    private lazy var contentView = UIView()
    
    private let mapView = NMFMapView()
    
    private let detailComplaintView: DetailComplaintView = {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2) 
        $0.layer.shadowRadius = 4
        return $0
    }(DetailComplaintView())
    
    private let deleteButton: UIButton = {
        $0.setTitle("삭제 요청", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return $0
    }(UIButton())
    
    private lazy var reportImageNumLabel: UILabel = {
        $0.text = "신고 사진 3개"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .black
        return $0
    }(UILabel())

    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    
//MARK: - Life Cycles
    init(complaint: ComplaintModel) {
        self.complaint = complaint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIandConstraints()
        configureMapView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
//MARK: - set UI
    func setUIandConstraints() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mapView)
        contentView.addSubview(backButton)
        contentView.addSubview(detailComplaintView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(reportImageNumLabel)
        contentView.addSubview(imageCollectionView)
        
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(350)
            make.width.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(55)
            make.leading.equalToSuperview().inset(18)
            make.height.width.equalTo(35)
        }
        detailComplaintView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).inset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(270)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(detailComplaintView.snp.bottom).inset(-20)
            make.trailing.equalToSuperview().inset(25)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        reportImageNumLabel.snp.makeConstraints { make in
            make.top.equalTo(detailComplaintView.snp.bottom).inset(-60)
            make.leading.equalToSuperview().inset(20)
        }
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(reportImageNumLabel.snp.bottom).inset(-13)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
            
            if detailImageList.count > 3 {
                make.height.equalTo(280)
            } else {
                make.height.equalTo(150)
            }
        }
    }

//MARK: - MapView
    private func configureMapView() {
        mapView.delegate = self
        
        let marker = NMFMarker()
        print("lat: \(complaint.latitude), lng: \(complaint.longitude)")
        marker.position = NMGLatLng(lat: complaint.latitude, lng: complaint.longitude)
        marker.mapView = mapView
        marker.iconImage = NMFOverlayImage(image: UIImage(systemName: "house")!)
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: complaint.latitude, lng: complaint.longitude)))
    }
    
    
//MARK: - Handler
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - NMFMapViewDelegate
extension DetailViewController: NMFMapViewDelegate {
    // 지도 탭 시
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        print("탭한 지역 - ")
        print("lat: \(latlng.lat), lng: \(latlng.lng)")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width / 3) - 7
        return CGSize(width: size, height: size)
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        guard let image = detailImageList[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configure(image: image)
        
        return cell
    }
}
