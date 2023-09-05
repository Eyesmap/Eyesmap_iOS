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
                print("DEBUG: 신고 조회 result - \(result)")
                completion(nil, result)
            case .failure(let error):
                print("DEBUG: 신고 조회 error - \(error)")
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
    
    // 상세 신고 조회
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
    
    // 신고하기
    func DangerRequest(reportId: String, completion: @escaping (Error?, DangerResultModel?) -> Void) {
        let router = reportRouter.danger
        
        let param = ["reportId": reportId]
        
        AF.request(router.url,
                   method: router.method,
                   parameters: param,
                   encoder: JSONParameterEncoder.default,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: DangerResultModel.self) { response in
            switch response.result {
            case .success(let result):
                print("신고하기 result = \(result)")
                completion(nil, result)
            case .failure(let error):
                print("신고하기 error = \(error)")
                completion(error, nil)
            }
        }
    }
    
    // 신고 삭제
    func deleteComplaintRequest(reportId: String, type: DeleteType.RawValue, completion: @escaping (Error?, MessageResultModel?) -> Void) {
        let router = reportRouter.deleteComplaint
        
        let param = ["reportId": reportId,
                     "deleteReason": type]
        
        AF.request(router.url,
                   method: router.method,
                   parameters: param,
                   encoder: JSONParameterEncoder.default,
                   headers: router.headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: MessageResultModel.self) { response in
            switch response.result {
            case .success(let result):
                print("신고 삭제 result = \(result)")
                completion(nil, result)
            case .failure(let error):
                print("신고 삭제 error = \(error)")
                completion(error, nil)
            }
        }
    }
    
    // 신고 복구
    func restoreComplaintRequest(images: [UIImage], reportId: String, completion: @escaping(Bool) -> Void) {
        let router = reportRouter.restoreComplaint
        
        //multipart formdata
        AF.upload(multipartFormData: { [weak self] multipartFormData in
            guard let self = self else { return }
            
            // 복구 사진 append
            for i in 0 ..< images.count {
                if let image = images[i].pngData() {
                    multipartFormData.append(image, withName: "images", fileName: self.getImageName(name: "restore"), mimeType: "image/jpeg")
                }
            }
            
            // parameter append
            let param = ["reportId": reportId]
            
            var requestData = ""
            do {
                let requestPayload = try JSONSerialization.data(withJSONObject: param, options: [])
                requestData = String(data: requestPayload, encoding: .utf8) ?? ""
            } catch {
                print(error.localizedDescription)
            }
            
            multipartFormData.append("\(requestData)".data(using: .utf8)!, withName: "createRestoreReportRequest", mimeType: "application/json")
            
        }, to: router.url, method: router.method, headers: router.headers)
        .responseDecodable(of: ResoreComplaintResultModel.self) { response in
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
    
    //신고 생성
    func createComplaintRequest(images: [UIImage], parameters: CreateComplaintRequestModel, completion: @escaping(Bool) -> Void) {
        let router = reportRouter.createComplaint
        
        //multipart formdata
        AF.upload(multipartFormData: { [weak self] multipartFormData in
            guard let self = self else { return }
            
            // 복구 사진 append
            for i in 0 ..< images.count {
                if let image = images[i].pngData() {
                    multipartFormData.append(image, withName: "images", fileName: self.getImageName(name: "restore"), mimeType: "image/jpeg")
                }
            }
            
            // parameter append
            var requestData = ""
            do {
                let requestPayload = try JSONSerialization.data(withJSONObject: parameters, options: [])
                requestData = String(data: requestPayload, encoding: .utf8) ?? ""
            } catch {
                print(error.localizedDescription)
            }
            
            multipartFormData.append("\(requestData)".data(using: .utf8)!, withName: "createRestoreReportRequest", mimeType: "application/json")
            
        }, to: router.url, method: router.method, headers: router.headers)
        .responseDecodable(of: CreateComplaintResultModel.self) { response in
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

//MARK: - 상세 신고 조회
struct DetailComplaintResultModel: Decodable {
    let message: String
    let result: DetailComplaintResultData
}

struct DetailComplaintResultData: Decodable {
    let address: String
    let reportDate: String
    let dangerBtnClicked: Bool
    let dangerousCnt: Int
}

//MARK: - 위험해요 요청
struct DangerResultModel: Decodable {
    let message: String
    let result: DangerResultData
}

struct DangerResultData: Decodable {
    let dangerousCnt: Int
    let dangerBtnClicked: Bool
}

//MARK: - 시설물 복구
struct ResoreComplaintResultModel: Decodable {
    let message: String
    let result: ResoreComplaintResultData
}

struct ResoreComplaintResultData: Decodable {
    let address: String
    let gpsX: Double
    let gpsY: Double
    let title: String
    let contents: String
    let damagedStatus: String
    let sort: String
    let imageUrls: [String]
    let accountId: Int
}

//MARK: - 신고 생성
struct CreateComplaintRequestModel: Encodable {
    let address: String
    let gpsX: Double
    let gpsY: Double
    let title: String
    let contents: String
    let damagedStatus: String
    let sort: String
}

struct CreateComplaintResultModel: Decodable {
    let message: String
    let result: CreateComplaintResultData
}

struct CreateComplaintResultData: Decodable {
    let address: String
    let gpsX: Double
    let gpsY: Double
    let title: String
    let contents: String
    let damagedStatus: String
    let sort: String
    let imageUrls: [String]
    let accountId: Int
}
