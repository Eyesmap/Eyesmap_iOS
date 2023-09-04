//
//  HomeComplaintView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import SnapKit
import SDWebImage

class HomeComplaintView: UIView {
    
    var model: TapedComplaintResultData? {
        didSet {
            configure()
        }
    }
    
//MARK: - Properties
    private lazy var titleLabel: UILabel = {
        $0.text = "인도 도로블럭 파손"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private lazy var tagLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .instanceBlackColor
        return $0
    }(UILabel())
    
    private lazy var complaintImageView: UIImageView = {
        $0.image = UIImage(named: "block")
        $0.layer.cornerRadius = 13
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var distanceLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .instanceBlackColor
        return $0
    }(UILabel())
    
    private lazy var statusLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .instanceBlackColor
        return $0
    }(UILabel())
    
    private let distanceStackView: UIStackView = {
        let distanceImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "distance")
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(19)
            }
            return imageView
        }()
        
        let leftDistanceLabel: UILabel = {
            let label = UILabel()
            label.text = "남은 거리"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .black
            return label
        }()
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubview(distanceImageView)
        $0.addArrangedSubview(leftDistanceLabel)
        
        return $0
    }(UIStackView())
    
    private lazy var statusStackView: UIStackView = {
        lazy var statusImageView: UIImageView = {
            var imageView = UIImageView()
            imageView.image = UIImage(named: "status_bad")
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(19)
            }
            return imageView
        }()
        
        let statusLabel: UILabel = {
            let label = UILabel()
            label.text = "상태"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .black
            return label
        }()
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubview(statusImageView)
        $0.addArrangedSubview(statusLabel)
        
        return $0
    }(UIStackView())
    
    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "reportDanger")
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(19)
        }
        return imageView
    }()
    
    private let statusCntLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    
    private lazy var reportDangerStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addArrangedSubview(statusImageView)
        $0.addArrangedSubview(statusCntLabel)
        
        return $0
    }(UIStackView())
    
    
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
        layer.cornerRadius = 13
        
        addSubview(titleLabel)
        addSubview(tagLabel)
        addSubview(complaintImageView)
        addSubview(distanceLabel)
        addSubview(statusLabel)
        addSubview(distanceStackView)
        addSubview(statusStackView)
        addSubview(reportDangerStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.leading.equalToSuperview().inset(24)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-7.5)
            make.leading.equalToSuperview().inset(24)
        }
        complaintImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        distanceStackView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).inset(-34)
            make.leading.equalToSuperview().inset(24)
        }
        statusStackView.snp.makeConstraints { make in
            make.top.equalTo(distanceStackView.snp.bottom).inset(-8)
            make.leading.equalToSuperview().inset(24)
        }
        distanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(distanceStackView.snp.centerY)
            make.leading.equalTo(distanceStackView.snp.trailing).inset(-60)
        }
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(statusStackView.snp.centerY)
            make.leading.equalTo(distanceLabel.snp.leading)
        }
        reportDangerStackView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(21)
            
        }
    }
    
    private func configure() {
        guard let model = model else { return }
        
        titleLabel.text = model.title
        if model.sort == SortType.dottedBlock.rawValue {
            tagLabel.text = "#점자블록"
        }
        if model.sort == SortType.acousticGuidenceSystem.rawValue {
            tagLabel.text = "#음향유도장치"
        }
        if model.sort == SortType.brailleInfoBoard.rawValue {
            tagLabel.text = "점자안내판"
        }
        
        if model.damagedStatus == DamageStatusType.normal.rawValue {
            statusLabel.text = "보통"
        }
        if model.damagedStatus == DamageStatusType.bad.rawValue {
            statusLabel.text = "나쁨"
        }
        if model.damagedStatus == DamageStatusType.severe.rawValue {
            statusLabel.text = "심각"
        }
        
        
        guard let url = URL(string:"\(model.imageUrls[0])") else { return }
        complaintImageView.sd_setImage(with:url, completed: nil)
        
        distanceLabel.text = DistanceFormatter.formatDistance(meters: Int(model.distance))
        statusCntLabel.text = "\(model.dangerousCnt)"
    }
}
