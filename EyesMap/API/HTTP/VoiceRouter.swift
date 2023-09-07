//
//  VoiceRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/09/07.
//

import Foundation
import Alamofire

enum VoiceRouter {
    case getVoice(reportId: String)
    case onOffVoice
    
}

extension VoiceRouter: HttpRouter {
    
    var url: String {
        return baseUrlString + path
    }
 
    var baseUrlString: String {
        return Secret.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .getVoice(let reportId):
            return "/api/voice/file/\(reportId)"
        case .onOffVoice:
            return "/api/voice/onoff"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVoice:
            return .get
        case .onOffVoice:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        guard let accessToken = TokenManager.getUserAccessToken() else { return HTTPHeaders() }
        switch self {
        case .getVoice:
            if TokenManager.getUserAccessToken() == nil {
                return ["Content-Type" : "application/json"]
            } else {
                return ["Content-Type" : "application/json",
                        "Authorization" : "\(accessToken)"]
            }
        case .onOffVoice:
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
