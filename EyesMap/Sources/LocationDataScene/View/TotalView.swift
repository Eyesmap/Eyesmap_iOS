//
//  TotalView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

class TotalView: UIView {

    //MARK: - Properties
    let label_1: UILabel = {
        $0.text = "서울 특별시 신고 현황 총 1,277"
        $0.font = UIFont.boldSystemFont(ofSize: 13)
        $0.textColor = .white
        return $0
    }(UILabel())
    let basedTimeLabel: UILabel = {
        var label = UILabel()
        label.text = "2023.08.08 10시 기준"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Set UI
    func setUI() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 10
        
        addSubview(label_1)
        addSubview(basedTimeLabel)
        
        label_1.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).inset(14)
            make.centerY.equalTo(self)
        }
        basedTimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.snp.trailing).inset(13.5)
        }
    }
}
