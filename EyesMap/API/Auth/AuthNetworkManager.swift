//
//  LoginNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/21.
//

import Foundation
import Alamofire

class AuthNetworkManager {
    //MARK: - shared
    static let shared = AuthNetworkManager()
    let authRouter = AuthRouter.self
    
    //MARK: - Functions
    // 로그인
    func loginRequest(userId: Int, completion: @escaping (LoginResultModel) -> Void) {
        let router = authRouter.login(userId: userId)
        
        print("loginURL = \(router.url)")
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: LoginResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
    
    // 로그아웃
    func logoutRequest(userId: Int, completion: @escaping (LogoutResultModel) -> Void) {
        let router = authRouter.logout
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: LogoutResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
                print(response.error ?? "")
            }
        }
    }
    
    
}


//MARK: - 카카오 로그인
struct LoginResultModel: Decodable {
    let message: String
    let result: LoginToken
}

struct LoginToken: Decodable {
    let accessToken: String
    let refreshToken: String
}

struct LogoutResultModel: Decodable {
    let message: String
}
