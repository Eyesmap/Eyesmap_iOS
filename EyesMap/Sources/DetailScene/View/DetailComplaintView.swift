//
//  DetailComplaintView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/10.
//

import UIKit
import SnapKit

class DetailComplaintView: UIView {
    
    var isSelected: Bool = false {
        didSet {
            configure()
        }
    }
    
//MARK: - Properties
    private let titleLabel: UILabel = {
        $0.text = "인도 도로블럭 파손"
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let tagLabel: UILabel = {
        $0.text = "#안전 신고"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
        return $0
    }(UILabel())
    
    private lazy var reporterLabel: UILabel = {
        // attributedString으로 변경 예정
        $0.text = "김민경 님의 신고"
        $0.font = UIFont.systemFont(ofSize: 13)
        return $0
    }(UILabel())
    
    private lazy var timeStampLabel: UILabel = {
        $0.text = "2023.08.10"
        $0.font = UIFont.systemFont(ofSize: 13)
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
    
    private let statusStackView: UIStackView = {
        let statusImageView: UIImageView = {
            let imageView = UIImageView()
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
    
    private let divideLine: UIView = {
        $0.backgroundColor = .darkGray
        return $0
    }(UIView())
    
    let dangerButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray2,
            .font: UIFont.boldSystemFont(ofSize: 13)]
        let attributedString = NSAttributedString(string: "위험해요 101", attributes: textAttributes)
        let combinedString = NSMutableAttributedString()
        combinedString.append(attributedString)
        $0.setAttributedTitle(combinedString, for: .normal)
        
        $0.setImage(UIImage(named: "danger"), for: .normal)
        $0.setImage(UIImage(named: "selectedDanger"), for: .selected)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 20)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.backgroundColor = UIColor.white
        $0.isSelected = false
        return $0
    }(UIButton())
    
    
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
        layer.cornerRadius = 15
        
        addSubview(titleLabel)
        addSubview(tagLabel)
        addSubview(reporterLabel)
        addSubview(timeStampLabel)
        addSubview(complaintImageView)
        addSubview(distanceLabel)
        addSubview(statusLabel)
        addSubview(distanceStackView)
        addSubview(statusStackView)
        addSubview(divideLine)
        addSubview(dangerButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.leading.equalToSuperview().inset(24)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-3)
            make.leading.equalToSuperview().inset(24)
        }
        reporterLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(24)
        }
        timeStampLabel.snp.makeConstraints { make in
            make.top.equalTo(reporterLabel.snp.bottom).inset(-2)
            make.leading.equalToSuperview().inset(24)
        }
        complaintImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(23)
            make.height.width.equalTo(100)
        }
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(complaintImageView.snp.bottom).inset(-20)
            make.trailing.equalToSuperview().inset(22)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).inset(-10)
            make.trailing.equalToSuperview().inset(22)
        }
        distanceStackView.snp.makeConstraints { make in
            make.centerY.equalTo(distanceLabel.snp.centerY)
            make.leading.equalToSuperview().inset(25)
            make.height.equalTo(22)
        }
        statusStackView.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel.snp.centerY)
            make.leading.equalToSuperview().inset(25)
            make.height.equalTo(22)
        }
        divideLine.snp.makeConstraints { make in
            make.top.equalTo(statusStackView.snp.bottom).inset(-18)
            make.leading.trailing.equalToSuperview().inset(11)
            make.height.equalTo(0.8)
        }
        dangerButton.snp.makeConstraints { make in
            make.top.equalTo(divideLine.snp.bottom).inset(-16)
            make.trailing.equalToSuperview().inset(17)
            make.height.equalTo(22)
            make.width.equalTo(120)
        }
    }
    
    func configure() {
        if isSelected {
            dangerButton.isSelected = isSelected
            let textAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 13)]
            let attributedString = NSAttributedString(string: "위험해요 101", attributes: textAttributes)
            let combinedString = NSMutableAttributedString()
            combinedString.append(attributedString)
            dangerButton.setAttributedTitle(combinedString, for: .normal)
        }
    }
}
