//
//  TermView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/15.
//

import UIKit
import SnapKit

class TermView: UIView {
    //MARK: - Properties
    let titleLabel: UILabel = {
        $0.text = "이미지"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    let imageButton: UIButton = {
        $0.setImage(UIImage(systemName: "chevron.right")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal), for: .normal)
        return $0
    }(UIButton())
    
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
    
    //MARK: - set UI
    private func setUI() {
        addSubview(titleLabel)
        addSubview(imageButton)
        addSubview(sepLine)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview()
        }
        imageButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        sepLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-18)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
    }
    
    // MARK: - Helper
}
