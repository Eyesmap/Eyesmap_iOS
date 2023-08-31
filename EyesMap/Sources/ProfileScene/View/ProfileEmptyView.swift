//
//  ProfileEmptyView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import UIKit
import SnapKit

class ProfileEmptyView: UIView {
    //MARK: - Properties
    private let emptyImageView: UIImageView = {
        $0.image = UIImage(named: "emptyLogo")
        return $0
    }(UIImageView())
    
    private let emptyLabel: UILabel = {
        $0.text = "신고한 내역이 없습니다."
        $0.textColor = .systemGray2
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Set UI
    private func setUI() {
        backgroundColor = .clear
        addSubview(emptyImageView)
        addSubview(emptyLabel)
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(42)
            make.height.equalTo(53)
            make.width.equalTo(40)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).inset(-18)
            make.centerX.equalToSuperview()
        }
    }
    
}
