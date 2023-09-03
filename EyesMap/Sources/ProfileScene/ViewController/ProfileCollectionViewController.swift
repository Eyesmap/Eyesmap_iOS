//
//  ProfileCollectionViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/13.
//

import UIKit
import SnapKit
import CoreLocation

class ProfileCollectionViewController: UIViewController {
    // MARK: - Properties
    
    enum ResultType {
        case report
        case sympathy
    }
    
    private let resultType: ResultType
    private let locationManager = LocationHandler.shared.locationManager
    
    private var reportModel: [GetReportListResult] = [] {
        didSet {
            if reportModel.count == 0 {
                emptyView.alpha = 1
            } else {
                emptyView.alpha = 0
            }
            collectionView.reloadData()
        }
    }
    private var sympathyModel: [GetReportListResult] = [] {
        didSet {
            if sympathyModel.count == 0 {
                emptyView.alpha = 1
            } else {
                emptyView.alpha = 0
            }
            collectionView.reloadData()
        }
    }
    
    private let collectionView: UICollectionView = {
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
        return cv
    }()
    
    private let emptyView: ProfileEmptyView = {
        $0.alpha = 0
        return $0
    }(ProfileEmptyView())
    
    // MARK: - Life Cycles
    init(resultType: ResultType) {
        self.resultType = resultType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
        setUI()
        getReportRequest()
        getSympathyRequest()
        
    }
    
    //MARK: - CollectionView Setting
    private func collectionViewSetting() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    // MARK: - Set UI
    private func setUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - API
    private func getReportRequest() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        ProfileNetworkManager.shared.getReportListRequest(userGpsX: currentUserlong, userGpsY: currentUserLat) { [weak self] (error, model) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                self?.reportModel = model.reportList
            }
        }
    }
    
    private func getSympathyRequest() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        ProfileNetworkManager.shared.getSympathyListRequest(userGpsX: currentUserlong, userGpsY: currentUserLat) { [weak self] (error, model) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                self?.sympathyModel = model.reportList
            }
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch resultType {
        case .report:
            return reportModel.count
        case .sympathy:
            return sympathyModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        switch resultType {
        case .report:
            let model = reportModel[indexPath.row]
            cell.imageUrl = model.imageName[0]
        case .sympathy:
            let model = sympathyModel[indexPath.row]
            cell.imageUrl = model.imageName[0]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch resultType {
        case .report:
            let model = reportModel[indexPath.row]
            
            let complaint = ComplaintLocation(reportId: model.reportId, gpsX: model.gpsX, gpsY: model.gpsY)
            let tapedComplaint = TapedComplaintResultData(reportId: model.reportId, sort: model.sort, damagedStatus: model.damagedStatus,
                                                          title: model.title, imageUrls: model.imageName, dangerousCnt: model.dangerousCnt, distance: model.distance)
            let detailVC = DetailViewController(complaint: complaint, tapedComplaintModel: tapedComplaint)
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        case .sympathy:
            let model = sympathyModel[indexPath.row]
            
            let complaint = ComplaintLocation(reportId: model.reportId, gpsX: model.gpsX, gpsY: model.gpsY)
            let tapedComplaint = TapedComplaintResultData(reportId: model.reportId, sort: model.sort, damagedStatus: model.damagedStatus,
                                                          title: model.title, imageUrls: model.imageName, dangerousCnt: model.dangerousCnt, distance: model.distance)
            let detailVC = DetailViewController(complaint: complaint, tapedComplaintModel: tapedComplaint)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.bounds.width / 3) - 7
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
