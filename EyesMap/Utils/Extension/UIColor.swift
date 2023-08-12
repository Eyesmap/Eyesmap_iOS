//
//  UIColor.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit

extension UIColor {
    static let alertDeleteButton = UIColor.rgb(red: 221, green: 112, blue: 97)
}

// RGB값을 받아서 UIColor를 리턴하는 함수
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

