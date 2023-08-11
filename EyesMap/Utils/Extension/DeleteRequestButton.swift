//
//  DeleteRequestButton.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit

class DeleteRequestButton: UIButton {
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        commonInit(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonInit(text: String) {
        setTitle(text, for: .normal)
        setTitleColor(UIColor.lightGray, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        contentHorizontalAlignment = .leading
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layer.cornerRadius = 10
        backgroundColor = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
}
