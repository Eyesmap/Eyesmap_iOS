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
                print("프로필 result = \(result)")
                completion(nil, result)
            case .failure(let error):
                print("프로필 error = \(error )")
                completion(error, nil)
            }
        }
    }
    
    // 신고 내역 조회
    func getReportListRequest(userGpsX: Double, userGpsY: Double, completion: @escaping (Error?, GetUserListResultData?) -> Void) {
        let router = profileRouter.getReportList
        
        let param = ["userGpsX": userGpsX,
                     "userGpsY": userGpsY]
        
        AF.request(router.url,
                   method: router.method,
                   parameters: param,
                   encoder: JSONParameterEncoder.default,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetUserListResultModel.self) { response in
            switch response.result {
            case .success(let result):
                print("신고 내역 result = \(result)")
                completion(nil, result.result)
            case .failure(let error):
                print("신고 내역 error = \(error)")
                completion(error, nil)
            }
        }
    }
    
    // 공감 내역 조회
    func getSympathyListRequest(userGpsX: Double, userGpsY: Double, completion: @escaping (Error?, GetUserListResultData?) -> Void) {
        let router = profileRouter.getSympathyList
        
        let param = ["userGpsX": userGpsX,
                     "userGpsY": userGpsY]
        
        AF.request(router.url,
                   method: router.method,
                   parameters: param,
                   encoder: JSONParameterEncoder.default,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: GetUserListResultModel.self) { response in
            switch response.result {
            case .success(let result):
                completion(nil, result.result)
                print("공감 내역 result = \(result)")
            case .failure(let error):
                print("공감 내역 error = \(error)")
                completion(error, nil)
            }
        }
    }
    
    // 기본 이미지 변경(프로필 삭제)
    func deleteProfileImageRequest(completion: @escaping () -> Void) {
        let router = profileRouter.deleteProfileImage
        
        AF.request(router.url,
                   method: router.method,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MessageResultModel.self) { response in
            switch response.result {
            case .success(let result):
                print("기본 이미지 변경 성공 = \(result)")
                completion()
            case .failure(let error):
                print("기본 이미지 변경 error = \(error )")
            }
        }
    }
    
    // 프로필 변경
    func updateProfileImageRequest(image: UIImage, nickname: String, completion: @escaping(Bool) -> Void) {
        let router = profileRouter.updateProfile
        
        AF.upload(multipartFormData: { [weak self] multipartFormData in
            guard let self = self else { return }
            
            // 복구 사진 append
            if let image = image.jpegData(compressionQuality: 0.7) {
                multipartFormData.append(image, withName: "image", fileName: self.getImageName(name: "profile"), mimeType: "image/jpeg")
            }
            
            // parameter append
            let param = ["nickname": nickname]
            
            var requestData = ""
            do {
                let requestPayload = try JSONSerialization.data(withJSONObject: param, options: [])
                requestData = String(data: requestPayload, encoding: .utf8) ?? ""
            } catch {
                print(error.localizedDescription)
            }
            
            multipartFormData.append("\(requestData)".data(using: .utf8)!, withName: "updateProfileImageReqeuestDto", mimeType: "application/json")
        }, to: router.url, method: router.method, headers: router.headers)
        .responseDecodable(of: MessageResultModel.self) { response in
            switch response.result {
            case .success(let data):
                print("신고 복구 result = \(data)")
                completion(true)
            case .failure(let error):
                print("신고 복구 error = \(error)")
                completion(false)
            }
        }
    }
    
    // 이미지 이름 생성
    func getImageName(name: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = formatter.string(from: Date())
        
        let imageName = "EyesMap_\(name)_\(now).jpeg"
        return imageName
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
    let imageName: [String]
    let gpsX: Double
    let gpsY: Double
    let sort: String
    let damagedStatus: String
    let dangerousCnt: Int
    let address: String
    let reportDate: String
    let dangerBtnClicked: Bool
    let distance: Double
    let title: String
}

//MARK: - 
