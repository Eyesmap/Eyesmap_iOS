//
//  ProfileRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case getProfile
    case getReportList
    case getSympathyList
    case deleteProfileImage
    case updateProfile
}

extension ProfileRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .getProfile:
            return "/api/account/info"
        case .getReportList:
            return "/api/account/report/list"
        case .getSympathyList:
            return "/api/account/dangerouscnt/list"
        case .deleteProfileImage:
            return "/api/account/profile/image/init"
        case .updateProfile:
            return "/api/account/profile/image/update"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .getReportList:
            return .post
        case .getSympathyList:
            return .post
        case .deleteProfileImage:
            return .get
        case .updateProfile:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = TokenManager.getUserAccessToken() else { return HTTPHeaders() }
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
