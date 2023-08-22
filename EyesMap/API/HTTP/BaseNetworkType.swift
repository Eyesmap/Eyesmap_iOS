//
//  BaseNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/21.
//

import Foundation

enum BaseNetworType: String, CaseIterable {
    //MARK: - Case
    case login
    case logout
    
    //MARK: - URL
    var url: String {
        switch self {
        case .login:
            <#code#>
        case .logout:
            <#code#>
        }
    }
    
}
