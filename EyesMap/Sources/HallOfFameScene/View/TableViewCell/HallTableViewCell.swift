//
//  HallTableViewCell.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/06.
//

import UIKit
import SnapKit

class HallTableViewCell: UITableViewCell {

    static let top3Identifier = "Top3HallTableViewCell"
    static let otherIdentifier = "OtherHallTableViewCell"
    
    var hallTop3Model: HallRankingListTop3? {
        didSet {
            top3Configure()
        }
    }
    var hallTheOtherModel: HallOtherRankingList? {
        didSet {
            theOtherConfigure()
        }
    }
    
    //MARK: - Properties
    private let ranking: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let medalImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let name: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let cnt: UILabel = {
        let label = UILabel()
        label.text = "총 18회"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        return label
    }()
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfile")
        imageView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return imageView
    }()
    
    var type: DataCellType = .top3
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        setUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - set UI
    func setUI() {
        self.backgroundColor = .clear
        contentView.addSubview(name)
        contentView.addSubview(cnt)
        contentView.addSubview(profileImage)
        
        switch type {
        case .top3:
            contentView.addSubview(medalImageView)
            name.font = UIFont.boldSystemFont(ofSize: 18)
            
            medalImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(26)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
            }
            name.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalTo(profileImage.snp.trailing).offset(12)
            }
        case .other:
            contentView.addSubview(ranking)
            name.font = UIFont.systemFont(ofSize: 13)
            
            ranking.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(32)
            }
            name.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalTo(profileImage.snp.trailing).offset(12)
            }
        }
        
        cnt.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(26)
        }
        profileImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).inset(59)
        }
    }
    
    //MARK: - Configure
    private func top3Configure() {
        guard let model = hallTop3Model else { return }
        
        let medalUrl = URL(string: model.medalImage)
        
        medalImageView.sd_setImage(with: medalUrl)
        name.text = "\(model.nickname)"
        cnt.text = "총 \(model.reportCnt) 회"
        let profileImg = URL(string: model.profileImageUrl)
        profileImage.sd_setImage(with: profileImg)
    }
    
    private func theOtherConfigure() {
        guard let model = hallTheOtherModel else { return }
        
//        ranking.text = "\(model.rank)"
//        name.text = "\(model.guName)구"
//        cnt.text = "총 \(model.reportCount) 회"
//        gu_id = "\(model.guNum)"
    }
}
