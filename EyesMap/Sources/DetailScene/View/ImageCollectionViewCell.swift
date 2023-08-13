//
//  ImageCollectionViewCell.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/10.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static let identifier = "ImageCollectionViewCell"
    
    var image: UIImage? {
        didSet {
            detailImageView.image = image
        }
    }
    
    //MARK: - Properties
    let detailImageView = UIImageView()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selector

    
    //MARK: - Functions
    private func setupUI() {
        detailImageView.layer.cornerRadius = 10
        detailImageView.clipsToBounds = true
        
        addSubview(detailImageView)
        
        detailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(image: UIImage) {
        self.image = image
    }
}
