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
    
    //MARK: - Properties
    private let scrollView = UIScrollView()
    let contentView = UIView()
    private let  totalReportView = TotalView()
    private let seoulMap = MapView(frame: CGRect(x: 0, y: 0, width: 375, height: 307))
    private let reportRanking = RankingView()
    private let jachiDetail = JachiDetailView()
    
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seoulMap.isUserInteractionEnabled = true
        
        setUI()
        seoulMap.addTarget()
        getLocationReportRequest()
    }
    
    //MARK: - setUI
    private func setUI() {
        view.backgroundColor = UIColor(red: 158/255, green: 186/255, blue: 208/255, alpha: 1)
        reportRanking.delegate = self
        seoulMap.delegate = self
        
        contentView.addSubview(totalReportView)
        contentView.addSubview(seoulMap)
        contentView.addSubview(reportRanking)
        contentView.addSubview(jachiDetail)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview() // == make.edges.equalTo(0)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1000)
        }
        totalReportView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(334.5)
            make.height.equalTo(46)
        }
        seoulMap.snp.makeConstraints { (make) in
            make.width.equalTo(375)
            make.height.equalTo(307)
            make.centerX.equalToSuperview()
            make.top.equalTo(totalReportView.snp.bottom).offset(34)
        }
        reportRanking.snp.makeConstraints { (make) in
            make.width.equalTo(337)
            make.height.equalTo(506)
            make.centerX.equalTo(contentView)
            make.top.equalTo(seoulMap.snp.bottom).offset(23)
        }
        jachiDetail.snp.makeConstraints { (make) in
            make.width.equalTo(337)
            make.height.equalTo(506)
            make.centerX.equalTo(contentView)
            make.top.equalTo(seoulMap.snp.bottom).offset(23)
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

    //MARK: - API
    private func getLocationReportRequest() {
        LocationReportRankingManger.shared.getLocationReport { (error, locationReport) in
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            }
            
            if let locationReport = locationReport {
                // 보고서를 성공적으로 가져온 경우 처리
                print("보고서: \(locationReport)")
                self.rankingModel = locationReport.result
            }
        }
    }
    
    // 버튼 누를 시
    private func getJachiRequest(_ s:String) {
        JachiReportRankingManger.shared.getJachiReport(s: s) { [weak self] (error, locationReport) in
            
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
    func tapedLocation(name: String) {
        self.jachiDetail.alpha = 1
        self.jachiDetail.titleLabel.text = name
        
        // 자치 API
        self.getJachiRequest(name)
    }
}

//MARK: - MapViewDelegate
extension LocationDataViewController: MapViewDelegate {
    func jachiViewAppear(isHidden: Bool, title: String) {
        if isHidden {
            jachiDetail.alpha = 0
        } else {
            jachiDetail.alpha = 1
            jachiDetail.titleLabel.text = title
        }
    }
}


