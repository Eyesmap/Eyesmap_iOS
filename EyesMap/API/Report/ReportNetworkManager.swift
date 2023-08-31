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
    func getComplaintsRequest(completion: @escaping (Error?, GetComplaintsResultModel?) -> Void) {
        let router = reportRouter.getComplaints
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetComplaintsResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    // 마크 탭 시 마크 표시된 신고만 조회
    func tapedComplaintRequest(parameters: TapedComplaintRequestModel, completion: @escaping (Error?, TapedComplaintResultModel?) -> Void) {
        let router = reportRouter.tapedComplaint
        
        AF.request(router.url,
                   method: router.method,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: TapedComplaintResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    func getDetailComplaintRequest(reportId: String, completion: @escaping (Error?, DetailComplaintResultModel?) -> Void) {
        let router = reportRouter.getDetailComplaint(reportId)
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DetailComplaintResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}


//MARK: - 신고(시설물) 목록 조회
struct GetComplaintsResultModel: Decodable {
    let message: String
    let result: [ComplaintLocation]
}

struct ComplaintLocation: Codable {
    let reportId: String
    let gpsX: Double
    let gpsY: Double
}

//MARK: - 마크 표시된 신고만 조회
struct TapedComplaintRequestModel: Encodable {
    let reportId: String
    let userGpsX: Double
    let userGpsY: Double
}

struct TapedComplaintResultModel: Decodable {
    let message: String
    let result: TapedComplaintResultData
}

struct TapedComplaintResultData: Decodable {
    let reportId: String
    let sort: String
    let damagedStatus: String
    let title: String
    let imageUrls: [String]
    let dangerousCnt: Int
    let distance: Double
}

//MARK: - 신고 상세 조회
struct DetailComplaintResultModel: Decodable {
    let message: String
    let result: DetailComplaintResultData
}

struct DetailComplaintResultData: Decodable {
    let address: String
    let contents: String
    let reportDate: String
}
