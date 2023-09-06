//
//  RankingView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

protocol RankingViewDelegate: AnyObject {
    func tapedLocation(name: String, gu_Id: Int)
}

class RankingView: UIView {

    var top3DataArray: [Top3Data] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var theOthersDataArray: [TheOthersData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: RankingViewDelegate?
    
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지역별 신고 순"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "횟수"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        return label
    }()
    private let line: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 315).isActive = true
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.layer.borderWidth = 0
        view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        return view
    }()
    
    let tableView = UITableView()
    var basedTimeLabel: UILabel = {
        var label = UILabel()
        label.text = "2023.08.08 10시 기준"
        label.textColor = UIColor(red: 85/255, green: 131/255, blue: 236/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.top3Identifier)
        tableView.register(RankingTableViewCell.self, forCellReuseIdentifier: RankingTableViewCell.otherIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        setUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Set UI
    func setUI() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
        
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(line)
        addSubview(tableView)
        addSubview(basedTimeLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).inset(24.62)
            make.top.equalTo(self.snp.top).inset(20)
        }
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).inset(25)
            make.trailing.equalTo(self.snp.trailing).inset(23)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalTo(self)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(285)
            make.bottom.equalTo(self.snp.bottom).inset(35)
        }
        basedTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).inset(21)
            make.leading.equalTo(self.snp.leading).inset(23)
        }
    }
}


extension RankingView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let top3Cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.top3Identifier, for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
            top3Cell.type = .top3
            
            let top3model = top3DataArray[indexPath.row]
            top3Cell.top3Model = top3model
            
            return top3Cell
        } else {
            guard let otherCell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.otherIdentifier, for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
            otherCell.type = .other
            
            let theOtherModel = theOthersDataArray[indexPath.row]
            otherCell.theOtherModel = theOtherModel
            
            return otherCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 36
        } else {
            return 32
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let top3model = top3DataArray[indexPath.row]
            
            for jachi in MapView.jachiArray {
                // 자치구 배열에 있는 객체의 text와 title이 같을 때
                if (jachi.titleLabel?.text?.components(separatedBy: " ")[0] == "\(top3model.guName)구") {
                    jachi.backgroundColor = UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)
                    jachi.setTitleColor(UIColor.black, for: .normal)
                }
            }
            self.delegate?.tapedLocation(name: top3model.guName, gu_Id: top3model.guNum)
        } else {
            let theOtherModel = theOthersDataArray[indexPath.row]
            
            for jachi in MapView.jachiArray {
                // 자치구 배열에 있는 객체의 text와 title이 같을 때
                if (jachi.titleLabel?.text?.components(separatedBy: " ")[0] == "\(theOtherModel.guName)구") {
                    jachi.backgroundColor = UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)
                    jachi.setTitleColor(UIColor.black, for: .normal)
                }
            }
            self.delegate?.tapedLocation(name: theOtherModel.guName, gu_Id: theOtherModel.guNum)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return top3DataArray.count
        } else {
            return theOthersDataArray.count
        }

    }
}
