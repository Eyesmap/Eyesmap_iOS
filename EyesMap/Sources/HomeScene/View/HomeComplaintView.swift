//
//  HomeComplaintView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import SnapKit

class HomeComplaintView: UIView {
//MARK: - Properties
    private lazy var titleLabel: UILabel = {
        $0.text = "인도 도로블럭 파손"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private lazy var tagLabel: UILabel = {
        $0.text = "#안전 신고"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
        return $0
    }(UILabel())
    
    private lazy var complaintImageView: UIImageView = {
        $0.image = UIImage(named: "block")
        $0.layer.cornerRadius = 13
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var distanceLabel: UILabel = {
        $0.text = "50"
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private lazy var statusLabel: UILabel = {
        $0.text = "나쁨"
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .black
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
    
    private let reportDangerStackView: UIStackView = {
        let statusImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "reportDanger")
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(19)
            }
            return imageView
        }()
        
        let statusLabel: UILabel = {
            let label = UILabel()
            label.text = "101"
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
            make.top.equalTo(titleLabel.snp.bottom).inset(-5)
            make.leading.equalToSuperview().inset(24)
        }
        complaintImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(80)
        }
        distanceStackView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).inset(-23)
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
            make.centerX.equalTo(distanceLabel.snp.centerX)
        }
        reportDangerStackView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(21)
            
        }
    }
}
