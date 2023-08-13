//
//  ProfileInstanceView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/13.
//

import UIKit
import SnapKit

class ProfileInstanceView: UIView {
//MARK: - Properties
    let titleLabel: UILabel = {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    let nickNameLabel: UILabel = {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let sepLine: UIView = {
        $0.backgroundColor = .systemGray
        return $0
    }(UIView())
    
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
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(nickNameLabel)
        addSubview(sepLine)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(3)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        sepLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(3)
            make.height.equalTo(0.8)
        }
    }
}

