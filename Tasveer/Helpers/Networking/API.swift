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
        return Alamofire.request(sessionRouter.signUp(params))
    }
    
    static func createUser(_ params: Parameters) -> DataRequest {
        return Alamofire.request(router.users(.create(params)))
    }
    
    static func detailUser(deviceId: String) -> DataRequest {
        return Alamofire.request(router.users(.user(identifier: deviceId)))
    }
    
    static func createGroup(_ params: Parameters) -> DataRequest {
        return Alamofire.request(router.groups(.create(params)))
    }
    
    static func detailGroup(deviceId: String) -> DataRequest {
        return Alamofire.request(router.groups(.group(identifier: deviceId)))
    }
    
    static func createMembership(_ params: Parameters) -> DataRequest {
        return Alamofire.request(router.memberships(params))
    }
}

private let baseURLString = "https://kuvakehys.herokuapp.com/"

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
    let token = "" // FIXME: read from local db
    return token
}
