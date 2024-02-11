//
//  RemoteApi.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 09/02/2024.
//

import Foundation
import Alamofire
import RxSwift
import CommonCrypto


public protocol RemoteAPI {
    func request<T: Codable>(endPoint: String, method: HTTPMethod, parameters: Parameters?) -> Single<T>
}

extension RemoteAPI {
    
    public func request<T: Codable>(endPoint: String, method: HTTPMethod, parameters: Parameters?) -> Single<T> {
        // Marvel API credentials
        let publicKey = "7228d468025a89283ad34342cf6f4c38"
        let privateKey = "9c8b77b8e205a82ca84ac70ce1932dd946bf5585"
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        
        let baseUrl = "https://gateway.marvel.com/v1/public/"
        let apiConstants = "?ts=\(timestamp)&apikey=\(publicKey)&hash=\(hash)"

        return Single.create { single in
           let request = AF.request("\(baseUrl)\(endPoint)\(apiConstants)", method: method, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: T.self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let resultObject):
                    single(.success(resultObject))
                case .failure(let error):
                    single(.failure(ErrorMessage(error: error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}




extension String {
    var md5: String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }

        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
