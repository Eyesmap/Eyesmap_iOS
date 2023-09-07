//
//  HallOfFameViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/28.
//

import UIKit
import SnapKit

class HallOfFameViewController: UIViewController {
    
    var hallModel: HallOfFameData? {
        didSet {
            configure()
        }
    }
    
    var hallMyInfoModel: MyHallData? {
        didSet {
            configure2()
        }
    }
    
    var hallMyInfo: MyHallData! {
        didSet {
            myFameView.hallMyInfo = hallMyInfo
        }
    }
    
    var hallTop3DataArray: [HallRankingListTop3] = [] {
        didSet {
            hallOfFameView.hallTop3DataArray = hallTop3DataArray
        }
    }
    
    var halltheOtherDataArray: [HallOtherRankingList] = [] {
        didSet {
            hallOfFameView.hallTheOtherDataArray = halltheOtherDataArray
        }
    }
    
    
    // MARK: - Properties
    private let myFameView = MyFameView()
    private let hallOfFameView = HallOfFameView()
    let gradientLayer = CAGradientLayer()
    
    private lazy var  backgroundView : UIView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let cv = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        cv.backgroundColor = UIColor(white: 1, alpha: 0)
        cv.setGradient(color1: .fametopColor, color2: .fameBottomColor)
        cv.clipsToBounds = false
        return cv
    }()
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHallData()
        getMine()
        setUI()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHallData()
    }
    
    // MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundView)

        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }

        backgroundView.addSubview(myFameView)
        backgroundView.addSubview(hallOfFameView)

        myFameView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(21)
        }
        hallOfFameView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(myFameView.snp.bottom).offset(26)
        }
    }
    
    // MARK: - Functions
    func getHallData() {
        HallOfFameManager.shared.getHallOfFame { [weak self] (error, hallModel) in
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            } else if let hallModel = hallModel {
                // 보고서를 성공적으로 가져온 경우 처리
                print("보고서: \(hallModel)")
                self?.hallTop3DataArray  = hallModel.result.rankingListTop3
                self?.halltheOtherDataArray = hallModel.result.otherRankingList
                
            }
        }
    }
    
    func getMine() {
        HallMyInfoManager.shared.getHallMyInfo { [weak self] (error, hallMyInfoModel) in
            if let error = error {
                // 오류가 발생한 경우 처리
                print("오류 발생: \(error.localizedDescription)")
            } else if let hallMyInfoModel = hallMyInfoModel {
                // 보고서를 성공적으로 가져온 경우 처리
                print("보고서: \(hallMyInfoModel)")
            
                self?.hallMyInfo = hallMyInfoModel.result

                
            }
        }
    }
    
    private func configure() {
        guard let hallModel = hallModel else {return}
        
        hallTop3DataArray = hallModel.rankingListTop3
        halltheOtherDataArray = hallModel.otherRankingList
        
    }
    
    private func configure2() {
        guard let hallMyInfoModel = hallMyInfoModel else {return}
        hallMyInfo = hallMyInfoModel
    }
    
    private func configureNavBar() {
        title = "명예의 전당"
        self.navigationController?.navigationBar.backgroundColor = .white
        backgroundView.setGradient(color1: .fametopColor, color2: .fameBottomColor)
    }
    
}
