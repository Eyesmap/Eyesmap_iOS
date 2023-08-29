//
//  ReportNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/29.
//

import Foundation
import Alamofire

class ReportNetworkManager {
    //MARK: - shared
    static let shared = ReportNetworkManager()
    let reportRouter = ReportRouter.self
    
    //MARK: - Functions
    // 신고(시설물) 조회
    func getComplaintsRequest(completion: @escaping (Error?, getComplaintsResultModel?) -> Void) {
        let router = reportRouter.getComplaints
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: getComplaintsResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
}

//parameters: parameter,
//encoding: JSONParameterEncoder.default,

//MARK: - 신고(시설물) 목록 조회
struct getComplaintsResultModel: Decodable {
    let message: String
    let result: [ComplaintLocation]
}

struct ComplaintLocation: Decodable {
    let reportId: String
    let gpsX: Double
    let gpsY: Double
}
