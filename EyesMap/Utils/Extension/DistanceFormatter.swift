//
//  DistanceFormatter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/09/04.
//

import Foundation

struct DistanceFormatter {
    
    static func formatDistance(meters: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if meters < 1000 {
            return "\(meters) m"
        } else {
            let kilometers = Double(meters) / 1000.0
            if let formattedKilometers = formatter.string(from: NSNumber(value: kilometers)) {
                return "\(formattedKilometers) km"
            } else {
                // 포맷 변환이 실패 시 원래 값 반환
                return "\(kilometers) km"
            }
        }
    }
}
