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
    case deleteComplaint
    case restoreComplaint
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
            return "/api/report/dangerouscnt"
        case .deleteComplaint:
            return "/api/report/delete"
        case .restoreComplaint:
            return "/api/report/create/restoration"
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
        case .deleteComplaint:
            return .delete
        case .restoreComplaint:
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
        case .getDetailComplaint:
            if TokenManager.getUserAccessToken() != nil {
                return ["Content-Type" : "application/json",
                        "Authorization" : "\(accessToken)"]
            } else {
                return ["Content-Type" : "application/json"]
            }
        case .danger:
            return ["Content-Type" : "application/json",
                    "Authorization" : "\(accessToken)"]
        case .deleteComplaint:
            return ["Content-Type" : "application/json",
                    "Authorization" : "\(accessToken)"]
        case .restoreComplaint:
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
