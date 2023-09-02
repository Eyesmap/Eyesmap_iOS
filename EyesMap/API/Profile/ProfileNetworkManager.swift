//
//  ProfileNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import Foundation
import Alamofire

class ProfileNetworkManager {
    //MARK: - shared
    static let shared = ProfileNetworkManager()
    let profileRouter = ProfileRouter.self
    
    //MARK: - Functions
    // 프로필 조회
    func getProfileRequest(completion: @escaping (Error?, GetProfileResultModel?) -> Void) {
        let router = profileRouter.getProfile

        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetProfileResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    func getReportListRequest(completion: @escaping (Error?, GetUserListResultData?) -> Void) {
        let router = profileRouter.getReportList
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetUserListResultModel.self) { response in
            switch response.result {
            case .success(let result):
                print("프로필 신고 result = \(result)")
                completion(nil, result.result)
            case .failure(let error):
                print("프로필 신고 error = \(error)")
                completion(error, nil)
            }
        }
    }
    
    func getSympathyListRequest(completion: @escaping (Error?, GetUserListResultData?) -> Void) {
        let router = profileRouter.getSympathyList
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetUserListResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result.result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
}

//MARK: - 개인 프로필 조회
struct GetProfileResultModel: Decodable {
    let message: String
    let result: GetProfileResultData
}

struct GetProfileResultData: Decodable {
    let nickname: String
    let profileImageUrl: String
    let imageName: String
}

//MARK: - 사용자 신고/공감 내역 조회
struct GetUserListResultModel: Decodable {
    let message: String
    let result: GetUserListResultData
}

struct GetUserListResultData: Decodable {
    let reportList: [GetReportListResult]
}

struct GetReportListResult: Decodable {
    let reportId: String
    let imageUrl: String
}

//MARK: - 
