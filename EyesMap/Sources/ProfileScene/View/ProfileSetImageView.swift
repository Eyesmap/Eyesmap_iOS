//
//  ProfileSetImageView.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/22.
//

import UIKit
import SnapKit

protocol ProfileSetImageViewDelegate: AnyObject {
    func presentPipView()
}

class ProfileSetImageView: UIView {
    //MARK: - Properties
    private lazy var backgroundView: UIView = {
        $0.backgroundColor = .darkGray
        return $0
    }(UIView())
    
    private lazy var cameraImage: UIButton = {
        $0.setImage(UIImage(systemName: "camera")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(cameraButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
    weak var delegate: ProfileSetImageViewDelegate?
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Set UI
    private func setUI() {
        addSubview(backgroundView)
        backgroundView.addSubview(cameraImage)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(23)
            make.height.equalTo(20)
        }
    }
    
    //MARK: - Handler
    @objc func cameraButtonTap() {
        self.delegate?.presentPipView()
    }
}
