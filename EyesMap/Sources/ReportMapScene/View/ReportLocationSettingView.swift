//
//  ReportLocationSettingView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/18.
//

import UIKit
import SnapKit

class ReportLocationSettingView: UIView {
//MARK: - Properties
    private let titleLabel: UILabel = {
        $0.text = "신고 위치를 확인해주세요!"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let locationLineView: UIView = {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = UIColor.systemGray2.cgColor
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    lazy var locationLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .black
        return $0
    }(UILabel())

    let locationSettingButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSAttributedString(string: "이 위치로 주소 설정", attributes: textAttributes)
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 28
        return $0
    }(UIButton())
    
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
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(locationLineView)
        locationLineView.addSubview(locationLabel)
        addSubview(locationSettingButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(19)
            make.height.equalTo(30)
        }
        locationLineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-18)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(45)
        }
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        locationSettingButton.snp.makeConstraints { make in
            make.top.equalTo(locationLineView.snp.bottom).inset(-24)
            make.leading.trailing.equalToSuperview().inset(19)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
    
}
