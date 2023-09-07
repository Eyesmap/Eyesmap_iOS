//
//  HallOfFameView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/06.
//

import UIKit
import SnapKit

class HallOfFameView: UIView {
    
    var hallTop3DataArray: [HallRankingListTop3] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var hallTheOtherDataArray: [HallOtherRankingList] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    
    //MARK: - Properties
    let tableView = UITableView()
    private let title: UILabel = {
        let title = UILabel()
        title.backgroundColor = .white
        title.text = "8월 신고자분들께 감사합니다"
        title.font = UIFont.boldSystemFont(ofSize: 17)
        let attributtedString = NSMutableAttributedString(string: title.text!)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 221/255, green: 112/255, blue: 97/255, alpha: 1), range: (title.text! as NSString).range(of:"8"))
                
        title.attributedText = attributtedString
        return title
    }()
    
    let line: UIView = {
        let line = UIView()
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.widthAnchor.constraint(equalToConstant: 315).isActive = true
        line.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
        line.layer.borderWidth = 1
        
        
        // 채워줘야할 부분
        return line
    }()
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HallTableViewCell.self, forCellReuseIdentifier: HallTableViewCell.top3Identifier)
        tableView.register(HallTableViewCell.self, forCellReuseIdentifier: HallTableViewCell.otherIdentifier)
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
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        self.widthAnchor.constraint(equalToConstant: 337).isActive = true
        self.heightAnchor.constraint(equalToConstant: 500).isActive = true
        self.layer.cornerRadius = 15
        
        self.backgroundColor = .white
        self.layer.backgroundColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
        
        addSubview(title)
        addSubview(line)
        addSubview(tableView)
        
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).inset(24)
            make.top.equalTo(self.snp.top).inset((17))
        }
        line.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(title.snp.bottom).offset(16)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
 

}

extension HallOfFameView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if indexPath.section == 0 {
            guard let top3Cell = tableView.dequeueReusableCell(withIdentifier: HallTableViewCell.top3Identifier, for: indexPath) as? HallTableViewCell else { return UITableViewCell() }
            top3Cell.type = .top3
            
            let model = hallTop3DataArray[indexPath.row]
            top3Cell.hallTop3Model = model
            
            return top3Cell
        } else {
            guard let otherCell = tableView.dequeueReusableCell(withIdentifier: HallTableViewCell.otherIdentifier, for: indexPath) as? HallTableViewCell else { return UITableViewCell() }
            otherCell.type = .other
            
            let model = hallTheOtherDataArray[indexPath.row]
            otherCell.hallTheOtherModel = model
            
            return otherCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 42
        } else {
            return 42
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return hallTop3DataArray.count
        } else {
            return hallTheOtherDataArray.count
        }

    }
}
