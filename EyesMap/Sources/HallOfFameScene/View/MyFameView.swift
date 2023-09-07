//
//  MyFameView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/28.
//

import UIKit
import SnapKit

class MyFameView: UIView {
    
    var hallMyInfo: MyHallData! {
        didSet {
            setApi()
        }
    }
    func setApi() {
        userName.text = hallMyInfo.nickname
        reportCnt.text = "총 \(hallMyInfo.reportCnt)회"
        let profileImg = URL(string: hallMyInfo.profileImageUrl)
        profileImage.sd_setImage(with: profileImg)
    }
    
    
    //MARK: - Properties
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfile")
        imageView.layer.cornerRadius = 25 / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "김미나"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let reportCnt: UILabel = {
        let label = UILabel()
        label.text = "총 40회"
        label.textColor = UIColor.rgb(red: 90, green: 89, blue: 90)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
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
    func setUI() {
        self.widthAnchor.constraint(equalToConstant: 337).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.layer.cornerRadius = 10
        
        self.backgroundColor = .white
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(reportCnt)
        
        profileImage.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).inset(23)
            make.centerY.equalTo(self)
            make.width.height.equalTo(21)
        }
        userName.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
            make.centerY.equalTo(self)
        }
        reportCnt.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).inset(26)
            make.centerY.equalTo(self)
        }
    }
}
