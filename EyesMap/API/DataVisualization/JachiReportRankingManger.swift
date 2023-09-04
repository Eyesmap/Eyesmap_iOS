//
//  JachiReportRankingManger.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/03.
//

import Foundation
import Alamofire

class JachiReportRankingManger {
    //MARK: - shared
    static let shared = JachiReportRankingManger()
    let reportRouter = ReportRouter.self
    
    //MARK: - Functons
    
    // 자치 신고순 api
    func getJachiReport(s: String, completion: @escaping (Error?, JachiReportRanking?) -> Void) {
        let router = RankingRouter.getJachiReport
        print(router.url+s)
        AF.request(router.url+s, method: router.method, headers: router.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of:JachiReportRanking.self) { response in
                switch response.result {
                case .success(let result):
                    print("자치 데이터 연동 성공-------")
                    completion(nil, result)
                case .failure(let error):
                    print("데이터 연동 실패-------")
                    completion(error, nil)
            }
        }
    }
    
    //
}

struct JachiReportRanking : Decodable {
    let message : String
    let result : JachiData
}

struct JachiData : Decodable {
    let top3Report : [JachiTop3Data?]
    let theOthers : [JachiTheOthersData?]
}

struct JachiTop3Data : Decodable {
    let reportId : String
    let rank : Int
    let count : Int
    let address : String
    let title : String
    let medal : String
}

struct JachiTheOthersData : Decodable {
    let reportId : String
    let rank : Int
    let count : Int
    let address : String
    let title : String
}
