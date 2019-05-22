//
//  DataRequest+NetResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Alamofire

struct ResponseError: Error {
    let error: Error
    let statusCode: Int
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}

extension DataRequest {
    @discardableResult
    func responseParsed<Type: Codable>(callback: @escaping (Swift.Result<Type, ResponseError>) -> Void) -> Self {
        return self.responseJSON { resp in
            guard let data = resp.data
                else {
                    callback(.failure(ResponseError(error: resp.error!, statusCode: resp.response?.statusCode ?? 0)))
                    return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
                
                let object = try decoder.decode(Type.self, from: data)
                callback(.success(object))
            }
            catch let error {
                callback(.failure(ResponseError(error: error, statusCode: resp.response?.statusCode ?? 0)))
            }
        }
    }
}
