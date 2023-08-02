//
//  Double.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/01.
//

import Foundation

// 라디안을 도로 변환하는 확장
extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }

    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
