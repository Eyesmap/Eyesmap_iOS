//
//  File.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/06.
//


import Foundation
import Alamofire

enum HallRouter {
    case getHallOfFame
    case getHallMyInfo
}

extension HallRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .getHallOfFame:
            return "/api/account/ranking/list"
        case .getHallMyInfo:
            return "/api/account/ranking/mine"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHallOfFame:
            return .get
        case .getHallMyInfo:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = TokenManager.getUserAccessToken() else { return HTTPHeaders() }
        print("-------------accessTokeon \(accessToken)")
        return ["Content-Type" : "application/json",
                "Authorization" : "\(accessToken)"]
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
