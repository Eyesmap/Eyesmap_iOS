//
//  VoiceNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/09/07.
//

import Foundation
import Alamofire

class VoiceNetworkManager {
    //MARK: - shared
    static let shared = VoiceNetworkManager()
    let voiceRouter = VoiceRouter.self
    
    //MARK: - Functions
    // 시설물 알림
    func getVoiceRequest(reportId: String, completion: @escaping (Error?, VoiceResultModel?) -> Void) {
        let router = voiceRouter.getVoice(reportId: reportId)
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: VoiceResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    // 음성 on/off 설정
    func voiceOnOffRequest(completion: @escaping (Error?, OnOffResultModel?) -> Void) {
        let router = voiceRouter.onOffVoice
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: OnOffResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
}

//MARK: - 시설물 알림
struct VoiceResultModel: Decodable {
    let message: String
    let result: VoiceResultData?
    let exception: String?
}

struct VoiceResultData: Decodable {
    let url: String
}

//MARK: - on/off
struct OnOffResultModel: Decodable {
    let message: String
    let result: Bool
}
