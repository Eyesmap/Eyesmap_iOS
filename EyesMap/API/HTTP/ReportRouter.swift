//
//  ReportRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import Foundation
import Alamofire

enum ReportRouter {
    case getComplaints
    case tapedComplaint
    case getDetailComplaint(_ reportId: String)
    case danger
}

extension ReportRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .getComplaints:
            return "/api/report/fetch"
        case .tapedComplaint:
            return "/api/report/fetch/mark"
        case .getDetailComplaint(let reportId):
            return "/api/report/fetch/detail?reportId=\(reportId)"
        case .danger:
            return "/api/report/dangerouscnt/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComplaints:
            return .get
        case .tapedComplaint:
            return .post
        case .getDetailComplaint:
            return .get
        case .danger:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = TokenManager.getUserAccessToken() else { return HTTPHeaders() }
        switch self {
        case .getComplaints:
            return ["Content-Type" : "application/json"]
        case .tapedComplaint:
            return ["Content-Type" : "application/json"]
        case .getDetailComplaint(_):
            return ["Content-Type" : "application/json"]
        case .danger:
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
