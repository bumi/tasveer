//
//  Router.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
    static var baseURLString: String? { get }
}

enum SessionRouter: BaseRouter {
    static var baseURLString: String?
    
    case signUp(params: Parameters)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "users"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURLString = SessionRouter.baseURLString,
            let url = Foundation.URL(string: baseURLString)
            else { throw RouterError.noBaseURL }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        let jsonEncoding = JSONEncoding.default
        switch self {
        case .signUp(let params):
            return try jsonEncoding.encode(urlRequest, with: params)
        }
    }
}

enum Router: BaseRouter {
    static var baseURLString: String?
    static var authToken: String?
    
    enum User {
        case me
        case user(deviceId: String)
    }
    
    enum Collection {
        case create(params: Parameters) // name, description
        case collection(identifier: String)
        case all
        case edit(identifier: String, params: Parameters)
        case invite(identifier: String, params: Parameters)
        case photos(identifier: String)
    }
    
    enum Invitation {
        case accept(identifier: String) // Invite identifier
    }
    
    enum Photo {
        case create(params: Parameters)
        case createToCollection(collectionId: String)
        case edit(identifier: String, params: Parameters)
        case delete(identifier: String)
        case appendTo(identifier: String, params: Parameters)
    }
    
    case users(User)
    case collections(Collection)
    case invitations(Invitation)
    case photos(Photo)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .collections(.create),
             .collections(.invite),
             .photos(.create),
             .photos(.createToCollection),
             .photos(.appendTo):
            return .post
        case .users(.me),
             .users(.user),
             .collections(.collection),
             .collections(.all),
             .collections(.photos):
            return .get
        case .collections(.edit),
             .invitations(.accept),
             .photos(.edit):
            return .put
        case .photos(.delete):
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .users(.me):
            return "users/me"
        case .users(.user(let deviceId)):
            return "users/\(deviceId)"
            
        case .collections(.create),
             .collections(.all):
            return "collections"
        case .collections(.collection(let identifier)),
             .collections(.edit(let identifier, _)):
            return "collections/\(identifier)"
        case .collections(.invite(let identifier, _)):
            return "collections/\(identifier)/invitations"
        case .collections(.photos(let identifier)):
            return "collections/\(identifier)/photos"
            
        case .invitations(.accept(let identifier)):
            return "/invitations/\(identifier)/accept"
            
        case .photos(.create):
            return "photos"
        case .photos(.createToCollection(let collectionId)):
            return "collections/\(collectionId)/photos"
        case .photos(.edit(let identifier, _)):
            return "photos/\(identifier)"
        case .photos(.delete(let identifier)):
            return "photos/\(identifier)"
        case .photos(.appendTo(let identifier)):
            return "photos/\(identifier)/collectionships"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let baseURLString = Router.baseURLString,
            let url = Foundation.URL(string: baseURLString)
            else { throw RouterError.noBaseURL }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = Router.authToken {
            urlRequest.setValue(token, forHTTPHeaderField: "X-API-KEY")
        }
        
        let jsonEncoding = JSONEncoding.default
        let urlEncoding = URLEncoding.default
        
        switch self {
        case .users(.me),
             .users(.user),
             .collections(.collection),
             .collections(.all),
             .collections(.photos),
             .invitations(.accept),
             .photos(.delete):
            return try jsonEncoding.encode(urlRequest)
            
        case .collections(.create(let params)),
             .collections(.edit(_, let params)),
             .collections(.invite(_, let params)),
             .photos(.create(let params)),
             .photos(.edit(_, let params)),
             .photos(.appendTo(_, let params)):
            return try jsonEncoding.encode(urlRequest, with: params)
        case .photos(.createToCollection):
            return try urlEncoding.encode(urlRequest, with: nil)
        }
    }
}
