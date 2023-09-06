//
//  ImageCollectionViewCell.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/16.
//

import UIKit
import SnapKit

class ReportImageCollectionViewCell: UICollectionViewCell {
//MARK: - Properties
    static let identifier = "ReportImageCollectionViewCell"
    
    var image: UIImage? {
        didSet {
            configure()
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let deleteBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.white
        btn.backgroundColor = UIColor.black
        btn.layer.cornerRadius = 10
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true // 너비를 20으로 설정
        btn.heightAnchor.constraint(equalToConstant: 20).isActive = true // 높이를 20으로 설정
        btn.clipsToBounds = true
        btn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        btn.layer.borderWidth = 1.0 // 테두리 두께 설정
        btn.layer.borderColor = UIColor.white.cgColor // 테두리 색상 설정

        return btn
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
    private func setUI() {
        addSubview(imageView)
        addSubview(deleteBtn)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).inset(10)
            make.trailing.equalTo(imageView.snp.trailing).inset(10)
        }
    }
    
//MARK: - Functions
    private func configure () {
        self.imageView.image = image
    }
}


