//
//  FinishedReportController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import SnapKit

protocol FinishedFloatingControllerDelegate: AnyObject {
    func dismiss()
}

enum FloatingType: CaseIterable {
    case delete
    case report
}

class FinishedFloatingController: UIViewController {
    
//MARK: - Properties
    lazy var scrollView: UIScrollView = {
        $0.backgroundColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.contentSize = contentView.bounds.size
        return $0
    }(UIScrollView())
    
    lazy var contentView = UIView()
    
    private let mainImageView: UIImageView = {
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .lightGray
        return $0
    }(UILabel())
    
    private lazy var buttonStackView: UIStackView = {
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private let okButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: "확인", attributes: textAttributes)
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 22
        $0.addTarget(self, action: #selector(okButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let reportListButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 12)]
        let attributedString = NSAttributedString(string: "신고내역 보기", attributes: textAttributes)
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.backgroundColor = .systemGray2
        $0.layer.cornerRadius = 22
        return $0
    }(UIButton())
    
    private let type: FloatingType
    weak var delegate: FinishedFloatingControllerDelegate?
    
//MARK: - Life Cycles
    init(type: FloatingType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
//MARK: - Set UI
    private func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(okButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).inset(-28)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
        }
        
        switch type {
        case .delete:
            self.mainImageView.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            self.titleLabel.text = "삭제가 요청되었습니다!"
            self.subTitleLabel.text = "신고해주셔서 감사합니다 :)"
            
        case .report:
            self.mainImageView.image = UIImage(named: "reportDanger")
            self.titleLabel.text = "신고가 완료되었습니다!"
            self.subTitleLabel.text = "신고해주셔서 감사합니다 :)"
            
//            buttonStackView.addArrangedSubview(reportListButton)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-52)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.height.equalTo(52)
        }
    }
    
//MARK: - Selector
    @objc func okButtonTap() {
        self.dismiss(animated: true)
        self.delegate?.dismiss()
    }
}
