//
//  LocationReportRanking.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/29.
//

import Foundation
import Alamofire

class LocationReportRankingManger {
    //MARK: - shared
    static let shared = LocationReportRankingManger()
    let rankingRouter = RankingRouter.self
    
    //MARK: - Functons
    
    // 지역별 신고순 api
    func getLocationReport(completion: @escaping (Error?, LocationReportRanking?) -> Void) {
        let router = rankingRouter.getLocationReport
        
        AF.request(router.url, method: router.method, headers: router.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of:LocationReportRanking.self) { response in
                switch response.result {
                case .success(let result):
                    print("데이터 연동 성공-------")
                    completion(nil, result)
                case .failure(let error):
                    print("데이터 연동 실패-------")
                    completion(error, nil)
            }
        }
    }
    
    //
}

struct LocationReportRanking : Decodable {
    let message : String
    let result : ResultData
}

struct ResultData : Decodable {
    let allReportsCnt: Int
    let currentDateAndHour: String
    let top3Location : [Top3Data]
    let theOthers : [TheOthersData]
}

struct Top3Data : Decodable {
    let rank : Int
    let guNum : Int
    let guName : String
    let reportCount : Int
    let medal : String
}

struct TheOthersData : Decodable {
    let rank : Int
    let guNum : Int
    let guName : String
    let reportCount : Int
}
