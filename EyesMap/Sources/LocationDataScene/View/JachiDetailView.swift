//
//  JachiDetailView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

class JachiDetailView: UIView {

    var jachiTop3DataArray: [JachiTop3Data] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var jachiTheOthersDataArray: [JachiTheOthersData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Properties
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "중구"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "위험해요 공감수"
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
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"),  for: .normal)
        return btn
    }()
    private let tableView = UITableView()
    private var basedTimeLabel: UILabel = {
        var label = UILabel()
        label.text = "2023.08.08 10시 기준"
        label.textColor = UIColor(red: 85/255, green: 131/255, blue: 236/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(JachiTableViewCell.self, forCellReuseIdentifier: "RankingTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
       
        setUI()
        target()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Set UI
    func setUI() {
        self.backgroundColor = .white
        self.alpha = 0
        self.layer.masksToBounds = false
        
        addSubview(titleLabel)
        addSubview(countLabel)
        addSubview(line)
        addSubview(backBtn)
        addSubview(tableView)
        addSubview(basedTimeLabel)
        
        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).inset(25)
            make.top.equalTo(self.snp.top).inset(25)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(backBtn.snp.trailing).offset(17.3)
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
            make.bottom.equalTo(self.snp.bottom).inset(50)
        }
        basedTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).inset(21)
            make.leading.equalTo(self.snp.leading).inset(23)
        }
    }
    
    
    
    //MARK: - target 함수
    func target() {
        self.backBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    
    
    //MARK: - @objc func
    @objc func close() {
        self.alpha = 0
        for name in MapView.jachiArray {
            name.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
            name.setTitleColor(UIColor.white, for: .normal)
        }
    }
}


extension JachiDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let top3Cell = tableView.dequeueReusableCell(withIdentifier: JachiTableViewCell.top3Identifier, for: indexPath) as? JachiTableViewCell,
              let otherCell = tableView.dequeueReusableCell(withIdentifier: JachiTableViewCell.otherIdentifier, for: indexPath) as? JachiTableViewCell else { return UITableViewCell()}
        
        top3Cell.type = .top3
        otherCell.type = .other
        
        if indexPath.section == 0 {
            let model = jachiTop3DataArray[indexPath.row]
            top3Cell.top3Model = model
            
            return top3Cell
        } else {
            let model = jachiTheOthersDataArray[indexPath.row]
            otherCell.theOtherModel = model
            
            return otherCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return jachiTop3DataArray.count
        } else {
            return jachiTheOthersDataArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else {
            return 50
        }
    }
    
    
}
