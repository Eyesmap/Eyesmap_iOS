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
    
    let deleteBtn : UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark")! as UIImage, for: .normal)
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
            make.top.leading.trailing.bottom.equalToSuperview()
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


