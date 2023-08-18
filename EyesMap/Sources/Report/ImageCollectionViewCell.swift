//
//  ImageCollectionViewCell.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/16.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let id = "imageCell"
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    
    let deleteBtn : UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(named: "closed")! as UIImage, for: .normal)
        return btn
    }()
    

   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(deleteBtn)
        imageView.frame = bounds  // cell 의 크기만큼
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top).inset(10)
            make.trailing.equalTo(imageView.snp.trailing).inset(10)
        }

        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Cunfigure (IMG: UIImage) {
        self.imageView.image = IMG
    }
}


