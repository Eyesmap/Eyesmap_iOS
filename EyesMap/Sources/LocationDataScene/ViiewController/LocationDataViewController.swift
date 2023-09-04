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
    
    static var top3DataArray: [Top3Data?] = []
    static var theOthersDataArray: [TheOthersData?] = []
    static var jachiTop3DataArray: [JachiTop3Data?] = []
    static var jachiTheOthersDataArray: [JachiTheOthersData?] = []
    
    //MARK: - Properties
    private let scrollView = UIScrollView()
    let contentView = UIView()
    private let  totalReportView = TotalView()
    private let seoulMap = MapView(frame: CGRect(x: 0, y: 0, width: 375, height: 307))
    private let reportRanking = RankingView()
    static let jachiDetail = JachiDetailView()
    
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.seoulMap.isUserInteractionEnabled = true
        LocationReportRankingManger.shared.getLocationReport { (error, locationReport) in
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            } else if let locationReport = locationReport {
                // 보고서를 성공적으로 가져온 경우 처리
                print("보고서: \(locationReport)")
                self.rankingModel = locationReport.result
            }
        }

        setUI()
        seoulMap.addTarget()
    }
    

    
    //MARK: - setUI
    private func setUI() {
        view.backgroundColor = UIColor(red: 158/255, green: 186/255, blue: 208/255, alpha: 1)
        
        contentView.addSubview(totalReportView)
        contentView.addSubview(seoulMap)
        contentView.addSubview(reportRanking)
        contentView.addSubview(LocationDataViewController.jachiDetail)
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
        LocationDataViewController.jachiDetail.snp.makeConstraints { (make) in
            make.width.equalTo(337)
            make.height.equalTo(506)
            make.centerX.equalTo(contentView)
            make.top.equalTo(seoulMap.snp.bottom).offset(23)
        }
    }
    
    private func configure() {
        guard let rankingModel = rankingModel else {return}
                
        // top3 ranking 받기
        for x in rankingModel.top3Location {
            LocationDataViewController.top3DataArray.append(x)
        }
        
        for x in rankingModel.theOthers {
            LocationDataViewController.theOthersDataArray.append(x)
        }
        
        reportRanking.tableView.reloadData()

    }
    
    private func configure2() {
        guard let jachiModel = jachiReportRankingModel else {return}
                
        // top3 ranking 받기
        for x in jachiModel.result.top3Report {
            LocationDataViewController.jachiTop3DataArray.append(x)
        }
        
        for x in jachiModel.result.theOthers {
            LocationDataViewController.jachiTheOthersDataArray.append(x)
        }
        
        reportRanking.tableView.reloadData()
    }
    
    private func jachiRequest(_ s:String) {
        JachiReportRankingManger.shared.getJachiReport(s: s) { [weak self] (error, locationReport) in
            
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            }
            
            if let locationReport = locationReport {
                // 성공적으로 가져온 경우 처리
                print("보고서: \(locationReport)")
                print("하이하이하이루")
                self?.jachiReportRankingModel = locationReport
//                self.rankingModel = locationReport.result
//                DispatchQueue.main.async {
//                   LocationDataViewController.jachiDetail.tableView.reloadData()
//                                }
            }
        }
    }
}


