//
//  ProfileRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import Foundation
import Alamofire

enum ProfileRouter {

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
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
    
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        
        }
        
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
    
}
