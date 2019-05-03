//
//  DataRequest+NetResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Alamofire

extension DataRequest {
    @discardableResult
    func responseParsed<Type: Codable>(callback: @escaping (Swift.Result<Type, Error>) -> Void) -> Self {
        return self.responseJSON { resp in
            guard let data = resp.data
                else {
                    callback(.failure(resp.error!))
                    return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
                
                let object = try decoder.decode(Type.self, from: data)
                callback(.success(object))
            }
            catch let error {
                callback(.failure(error))
            }
        }
    }
}
