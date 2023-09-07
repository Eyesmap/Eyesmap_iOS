//
//  LocationDataViewController.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

class LocationDataViewController: UIViewController {

    var rankingModel: ResultData? {
        didSet {
            configure()
        }
    }
    var jachiReportRankingModel: JachiReportRanking? {
        didSet {
            configure2()
        }
    }
    var top3DataArray: [Top3Data] = [] {
        didSet {
            reportRanking.top3DataArray = top3DataArray
        }
    }
    var theOthersDataArray: [TheOthersData] = [] {
        didSet {
            reportRanking.theOthersDataArray = theOthersDataArray
        }
    }
    var jachiTop3DataArray: [JachiTop3Data] = [] {
        didSet {
            jachiDetail.jachiTop3DataArray = jachiTop3DataArray
        }
    }
    var jachiTheOthersDataArray: [JachiTheOthersData] = [] {
        didSet {
            jachiDetail.jachiTheOthersDataArray = jachiTheOthersDataArray
        }
    }
    var baseTime: String? {
        didSet {
            configureBaseTime()
        }
    }
    
    //MARK: - Properties
    private let scrollView = UIScrollView()
    let contentView: UIView = {
        $0.backgroundColor = UIColor.rgb(red: 158, green: 186, blue: 208)
        return $0
    }(UIView())
    private let  totalReportView = TotalView()
    private let seoulMap = MapView(frame: CGRect(x: 0, y: 0, width: 375, height: 307))
    private lazy var reportRanking = RankingView()
    private lazy var jachiDetail = JachiDetailView()
    
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seoulMap.isUserInteractionEnabled = true
        
        setUI()
        configureNavBar()
        seoulMap.addTarget()
        getLocationReportRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocationReportRequest()
    }
    
    //MARK: - setUI
    private func setUI() {
        view.backgroundColor = .white
        reportRanking.delegate = self
        seoulMap.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(totalReportView)
        contentView.addSubview(seoulMap)
        contentView.addSubview(reportRanking)
        contentView.addSubview(jachiDetail)
        
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        totalReportView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).inset(16)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(46)
        }
        seoulMap.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(307)
            make.top.equalTo(totalReportView.snp.bottom).offset(34)
        }
        reportRanking.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(600)
            make.top.equalTo(seoulMap.snp.bottom).offset(23)
        }
        jachiDetail.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(650)
            make.top.equalTo(seoulMap.snp.bottom).offset(23)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
    
    //MARK: - Configure
    private func configure() {
        guard let rankingModel = rankingModel else {return}
                
        // top3 ranking 받기
        top3DataArray = rankingModel.top3Location
        // 나머지 받기
        theOthersDataArray = rankingModel.theOthers
    }
    
    private func configure2() {
        guard let jachiModel = jachiReportRankingModel else {return}
                
        // top3 ranking 받기
        jachiTop3DataArray = jachiModel.result.top3Report
        // 나머지 받기
        jachiTheOthersDataArray = jachiModel.result.theOthers
    
    }
    
    private func configureBaseTime() {
        guard let baseTime = baseTime else { return }
        
        reportRanking.basedTimeLabel.text = baseTime
        jachiDetail.basedTimeLabel.text = baseTime
    }
    
    private func configureNavBar() {
        title = "시설물 신고 데이터"
        self.navigationController?.navigationBar.backgroundColor = .white
    }

    //MARK: - API
    private func getLocationReportRequest() {
        LocationReportRankingManger.shared.getLocationReport { [weak self] (error, locationReport) in
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            }
            
            if let locationReport = locationReport {
                // 보고서를 성공적으로 가져온 경우 처리
                print("보고서: \(locationReport)")
                self?.rankingModel = locationReport.result
                self?.baseTime = locationReport.result.currentDateAndHour
                self?.totalReportView.label_1.text = "서울특별시 신고 현황 총 \(locationReport.result.allReportsCnt)개"
                self?.totalReportView.basedTimeLabel.text = locationReport.result.currentDateAndHour
            }
        }
    }
    
    // 버튼 누를 시
    private func getJachiRequest(gu_id: Int) {
        JachiReportRankingManger.shared.getJachiReport(gu_Id: gu_id) { [weak self] (error, locationReport) in
            
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            }
            
            if let locationReport = locationReport {
                // 성공적으로 가져온 경우 처리
                print("보고서: \(locationReport)")
                self?.jachiReportRankingModel = locationReport
            }
        }
    }
}

//MARK: - RankingViewDelegate
extension LocationDataViewController: RankingViewDelegate {
    // 지역별 셀을 눌렀을 때
    func tapedLocation(name: String, gu_Id: Int) {
        self.jachiDetail.alpha = 1
        self.jachiDetail.titleLabel.text = "\(name)구"
        
        // 자치 API
        self.getJachiRequest(gu_id: gu_Id)
    }
}

//MARK: - MapViewDelegate
extension LocationDataViewController: MapViewDelegate {
    func jachiViewAppear(isHidden: Bool, title: String, gu_Id: Int) {
        if isHidden {
            jachiDetail.alpha = 0
        } else {
            jachiDetail.alpha = 1
            jachiDetail.titleLabel.text = title
            self.getJachiRequest(gu_id: gu_Id)
        }
    }
}


