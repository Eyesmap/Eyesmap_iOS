//
//  RankingView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

class RankingView: UIView {

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
    private var first_cell = Top3View(frame: .zero, imgName: "gold-medal", title: "서대문구", cnt: "40")
    private var second_cell = Top3View(frame: .zero, imgName: "silver-medal", title: "강남구", cnt: "28")
    private var third_cell = Top3View(frame: .zero, imgName: "bronze-medal", title: "강북구", cnt: "18")
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RankingTableViewCell.self, forCellReuseIdentifier: "RankingTableViewCell")
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
        addSubview(first_cell)
        addSubview(second_cell)
        addSubview(third_cell)
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
        first_cell.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(16)
            make.centerX.equalTo(self)
        }
        second_cell.snp.makeConstraints {(make) in
            make.top.equalTo(first_cell.snp.bottom).offset(14)
            make.centerX.equalTo(self)
        }
        third_cell.snp.makeConstraints { (make) in
            make.top.equalTo(second_cell.snp.bottom).offset(14)
            make.centerX.equalTo(self)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(third_cell.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.width.equalTo(285)
            make.bottom.equalTo(self.snp.bottom).inset(50)
        }
        basedTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).inset(21)
            make.leading.equalTo(self.snp.leading).inset(23)
        }
    }
}


extension RankingView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as? RankingTableViewCell else { return UITableViewCell()}

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
}
