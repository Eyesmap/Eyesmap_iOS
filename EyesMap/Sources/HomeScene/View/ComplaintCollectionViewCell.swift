//
//  ComplaintCollectionViewCell.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/07.
//

import UIKit
import SnapKit

class ComplaintCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    static let identifier = "ComplaintCollectionViewCell"
    
    //MARK: - Properties
    
    private let boardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "blueBoard")
       return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사고다발구역"
        label.textColor = .black
//        label.font
//        label.textColor = .rgb(red: 102, green: 102, blue: 102)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "보도블럭 파손"
        label.textColor = .black
        return label
    }()
    
    lazy var complaintImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "block")
        imageView.layer.cornerRadius = 13
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    
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
        backgroundColor = .white
        layer.cornerRadius = 13
        clipsToBounds = true 
        addSubview(boardImageView)
        addSubview(titleLabel)
        addSubview(tagLabel)
        addSubview(complaintImageView)
        
        boardImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalTo(19)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(boardImageView.snp.top)
            make.leading.equalTo(boardImageView.snp.trailing).inset(-8)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        complaintImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(18)
            make.width.height.equalTo(111)
        }
    }
    
    private func configure() {
        
    }
}
