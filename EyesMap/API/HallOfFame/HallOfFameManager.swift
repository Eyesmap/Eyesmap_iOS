//
//  HallOfFameManager.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/06.
//

import Foundation
import Alamofire

class HallOfFameManager {
    //MARK: - shared
    static let shared = HallOfFameManager()
    let hallRouter = HallRouter.self
    
    //MARK: - Functons
    
    // 신고자 명예 랭킹
    func getHallOfFame( completion: @escaping (Error?, HallOfFame?) -> Void) {
        let router = hallRouter.getHallOfFame
        
        AF.request(router.url, method: router.method, headers: router.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of:HallOfFame.self) { response in
                switch response.result {
                case .success(let result):
                    print("자치 데이터 연동 성공-------")
                    completion(nil, result)
                case .failure(let error):
                    print("데이터 연동 실패-------")
                    completion(error, nil)
            }
            print(router.url)
        }
    }
    
    //
}

struct HallOfFame : Decodable {
    let message : String
    let result : HallOfFameData
}

struct HallOfFameData : Decodable {
    let rankingListTop3 : [HallRankingListTop3]
    let otherRankingList : [HallOtherRankingList]
}

struct HallRankingListTop3 : Decodable {
    let rank : Int
    let userId : Int
    let nickname : String
    let profileImageUrl : String
    let reportCnt : Int
    let medalImage : String
}

struct HallOtherRankingList : Decodable {
    let rank : Int
    let userId : Int
    let nickname : String
    let profileImageUrl : String
    let reportCnt : Int
}
