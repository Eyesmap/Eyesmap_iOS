//
//  ImageCollectionViewCell.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/10.
//

import UIKit
import SnapKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static let identifier = "ImageCollectionViewCell"
    
    var imageUrl: String? {
        didSet {
            configure()
        }
    }
    
    var image: UIImage? {
        didSet {
            configureImage()
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
    
    func configure() {
        guard let imageUrl = imageUrl else { return }
        
        let url = URL(string: "\(imageUrl)")
        detailImageView.sd_setImage(with: url)
    }
    
    func configureImage() {
        guard let image = image else { return }
        
        detailImageView.image = image
    }
}
