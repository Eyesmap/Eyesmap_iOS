//
//  HallMyInfo.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/09/07.
//

import Foundation
import Alamofire

class HallMyInfoManager {
    //MARK: - shared
    static let shared = HallMyInfoManager()
    let hallRouter = HallRouter.self
    
    //MARK: - Functons
    
    // 신고자 명예 랭킹
    func getHallMyInfo( completion: @escaping (Error?, HallMyInfo?) -> Void) {
        let router = hallRouter.getHallMyInfo
        
        AF.request(router.url, method: router.method, headers: router.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of:HallMyInfo.self) { response in
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

struct HallMyInfo : Decodable {
    let message : String
    let result : MyHallData
}

struct MyHallData : Decodable {
    let nickname : String
    let profileImageUrl : String
    let reportCnt : Int
}
