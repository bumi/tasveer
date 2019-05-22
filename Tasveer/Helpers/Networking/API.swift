//
//  API.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Alamofire

struct API {
    static func signUp(_ params: Parameters) -> DataRequest {
        return Alamofire.request(sessionRouter.signUp(params: params))
    }
    
    static func signIn(deviceId: String, _ params: Parameters) -> DataRequest {
        return Alamofire.request(router.users(.user(deviceId: deviceId)))
    }
}

// Photos
extension API {
    static func uploadPhoto(collectionId: String) -> URLRequestConvertible{
        return router.photos(.createToCollection(collectionId: collectionId))
    }
}

private let baseURLString = "https://kuvakehys-tasveer.herokuapp.com/"

private var sessionRouter: SessionRouter.Type {
    SessionRouter.baseURLString = baseURLString
    return SessionRouter.self
}

private var router: Router.Type {
    Router.baseURLString = baseURLString
    Router.authToken = token
    
    return Router.self
}

private var token: String? {
    let token = "usr-50f629bf-a0d3-4150-986b-5172114"//AuthManager.shared.token ?? ""
    return token
}
