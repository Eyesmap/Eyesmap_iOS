//
//  FinishedReportController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import SnapKit

protocol FinishedReportControllerDelegate: AnyObject {
    func dismiss()
}

class FinishedReportController: UIViewController {
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
    
    private let checkImageView: UIImageView = {
        $0.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.text = "삭제가 요청되었습니다!"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.text = "신고해주셔서 감사합니다 :)"
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = .lightGray
        return $0
    }(UILabel())
    
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
    
    weak var delegate: FinishedReportControllerDelegate?
    
//MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
//MARK: - Set UI
    private func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(checkImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(okButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        checkImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(41)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(checkImageView.snp.bottom).inset(-28)
            make.centerX.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.centerX.equalToSuperview()
        }
        okButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-52)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
            make.height.equalTo(52)
        }
    }
    
//MARK: - Selector
    @objc func okButtonTap() {
        self.dismiss(animated: true)
        delegate?.dismiss()
    }
}
