//
//  GeoCodingNetworkManager.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/19.
//

import Foundation
import Alamofire

class GeoCodingNetworkManager {
    
    static let shared = GeoCodingNetworkManager()
    
    func reverseGeocode(latitude: Double, longitude: Double, completion: @escaping(String) -> Void) {
        let url = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=\(longitude),\(latitude)&sourcecrs=epsg:4326&output=json&orders=roadaddr"

        let headers: HTTPHeaders = [
            "X-NCP-APIGW-API-KEY-ID": Secret.shared.clientId,
            "X-NCP-APIGW-API-KEY": Secret.shared.clientSecret
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: GeoCodingModel.self) { response in
                switch response.result {
                case .success(let result):
                    if let firstResult = result.results.first {
                        let city = firstResult.region.area1.name
                        let city2 = firstResult.region.area2.name
                        let city3 = firstResult.region.area3.name
                        let city4 = firstResult.region.area4.name
                        let value = firstResult.land.addition0.value
                        
                        let fullAddress = "\(city) \(city2) \(city3) \(city4) \(value)"
                        completion(fullAddress)
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
}
