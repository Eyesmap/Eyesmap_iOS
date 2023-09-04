//
//  RankingRouter.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/31.
//

import Foundation
import Alamofire

enum RankingRouter {
    case getLocationReport
    case getJachiReport
}

extension RankingRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .getLocationReport:
            return "api/dataanl/gu/ranking/list"
        case .getJachiReport:
            return "api/dataanl/fetch/count/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getLocationReport:
            return .get
        case .getJachiReport:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type" : "application/json"]
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
