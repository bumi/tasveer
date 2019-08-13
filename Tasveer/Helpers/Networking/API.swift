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

// Collections
extension API {
    static func createCollection(_ params: Parameters) -> DataRequest {
        return Alamofire.request(router.collections(.create(params: params)))
    }
    
    static func editCollection(_ params: Parameters, identifier: String) -> DataRequest {
        return Alamofire.request(router.collections(.edit(identifier: identifier, params: params)))
    }
    
    static func invitePerson(_ params: Parameters, identifier: String) -> DataRequest {
        return Alamofire.request(router.collections(.invite(identifier: identifier, params: params)))
    }
    
    static func fetchCollection(for identifier: String) -> DataRequest {
        return Alamofire.request(router.collections(.collection(identifier: identifier)))
    }
}

// Invitations
extension API {
    static func acceptInvite(for identifier: String) -> DataRequest {
        return Alamofire.request(router.invitations(.accept(identifier: identifier)))
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
    let token = AuthManager.shared.token ?? ""
    return token
}
