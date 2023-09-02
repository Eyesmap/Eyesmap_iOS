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
    
    var detailModel: DetailComplaintResultData? {
        didSet {
            print("detailModel configured")
            configureDetailModel()
        }
    }
    
    var tapedComplaintModel: TapedComplaintResultData? {
        didSet {
            configureTapedComplaintModel()
            print("tapedComplaintModel configured")
        }
    }
    
//MARK: - Properties
    private let titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 19)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let tagLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .darkGray
        return $0
    }(UILabel())
    
    private lazy var addressLabel: UILabel = {
        // attributedString으로 변경 예정
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor.rgb(red: 85, green: 131, blue: 236)
        return $0
    }(UILabel())
    
    private lazy var timeStampLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .darkGray
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
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private lazy var statusLabel: UILabel = {
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
    
    lazy var dangerButton: UIButton = {
        let attributedString = getAttributeString(isSelected: self.isSelected, text: "위험해요 0")
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
        addSubview(addressLabel)
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
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).inset(-10)
            make.leading.equalToSuperview().inset(24)
        }
        timeStampLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).inset(-2)
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
            make.width.greaterThanOrEqualTo(100)
        }
    }
    
//MARK: - Configure
    private func configure() {
        guard let tapedComplaintModel = tapedComplaintModel else { return }
        
        dangerButton.isSelected = isSelected
        let attributedString = getAttributeString(isSelected: isSelected, text: "위험해요 \(tapedComplaintModel.dangerousCnt)")
        print(attributedString)
        let combinedString = NSMutableAttributedString()
        combinedString.append(attributedString)
        dangerButton.setAttributedTitle(combinedString, for: .normal)
    }
    
    private func configureDetailModel() {
        guard let model = detailModel else { return }
        
        addressLabel.text = model.address
        isSelected = model.dangerBtnClicked
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let reportDate = formatter.date(from: model.reportDate) {
            formatter.dateFormat = "yyyy.MM.dd"
            let formattedDate = formatter.string(from: reportDate)
            timeStampLabel.text = "\(formattedDate)"
        } else {
            print("날짜 변환 실패")
        }
    }
    
    private func configureTapedComplaintModel() {
        guard let tapedComplaintModel = tapedComplaintModel else { return }
        
        titleLabel.text = tapedComplaintModel.title
        if tapedComplaintModel.sort == SortType.dottedBlock.rawValue {
            tagLabel.text = "#점자블록"
        }
        if tapedComplaintModel.sort == SortType.acousticGuidenceSystem.rawValue {
            tagLabel.text = "#음향유도장치"
        }
        if tapedComplaintModel.sort == SortType.brailleInfoBoard.rawValue {
            tagLabel.text = "점자안내판"
        }
        
        if tapedComplaintModel.damagedStatus == DamageStatusType.normal.rawValue {
            statusLabel.text = "보통"
        }
        if tapedComplaintModel.damagedStatus == DamageStatusType.bad.rawValue {
            statusLabel.text = "나쁨"
        }
        if tapedComplaintModel.damagedStatus == DamageStatusType.severe.rawValue {
            statusLabel.text = "심각"
        }
        
        guard let url = URL(string:"\(tapedComplaintModel.imageUrls[0])") else { return }
        complaintImageView.sd_setImage(with:url, completed: nil)
        
        distanceLabel.text = "\(tapedComplaintModel.distance) M"
        let attributedString = getAttributeString(isSelected: self.isSelected, text: "위험해요 \(tapedComplaintModel.dangerousCnt)")
        let combinedString = NSMutableAttributedString()
        combinedString.append(attributedString)
        dangerButton.setAttributedTitle(combinedString, for: .normal)
        
    }
    
    private func getAttributeString(isSelected: Bool, text: String) -> NSAttributedString {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: isSelected ? UIColor.rgb(red: 221, green: 112, blue: 97) : UIColor.systemGray2,
            .font: UIFont.boldSystemFont(ofSize: 13)]
        let attributedString = NSAttributedString(string: text, attributes: textAttributes)
        
        return attributedString
    }
}
