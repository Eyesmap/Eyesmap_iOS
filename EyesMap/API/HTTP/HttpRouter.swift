//
//  HttpRouter.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/21.
//

import Alamofire
import Foundation

protocol HttpRouter {
    var url: String { get }
    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    func body() throws -> Data?
}

// Default
extension HttpRouter {
    var headers: HTTPHeaders? { return nil }
    var parameters: Parameters? { return nil }
    func body() throws -> Data? { return nil }
    
    func asUrlRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
}
