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
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getComplaints:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getComplaints:
            return ["Content-Type" : "application/json"]
        }
        
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
