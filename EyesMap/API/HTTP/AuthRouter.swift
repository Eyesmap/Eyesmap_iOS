//
//  AuthRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/21.
//

import Foundation
import Alamofire

enum AuthRouter {
    case login(userId : Int)
    case logout
}

extension AuthRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .login(let userId):
            return "/login/oauth/\(userId)"
        case .logout:
            return "/api/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .logout:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = TokenManager.getUserAccessToken() else { return HTTPHeaders() }
        switch self {
        case .login:
            return ["Content-Type" : "application/json"]
        case .logout:
            return ["Content-Type" : "application/json",
                    "Authorization" : "\(accessToken)"]
        }
        
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
