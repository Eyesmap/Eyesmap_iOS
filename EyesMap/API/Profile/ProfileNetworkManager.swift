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
//    func getComplaintsRequest(completion: @escaping (Error?, getComplaintsResultModel?) -> Void) {
//        let router = reportRouter.getComplaints
//
//        AF.request(router.url,
//                   method: router.method,
//                   headers: router.headers)
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: getComplaintsResultModel.self) { response in
//            switch response.result {
//            case .success(let result):
//                completion(nil, result)
//            case .failure(let error):
//                completion(error, nil)
//            }
//        }
//    }
    
}
