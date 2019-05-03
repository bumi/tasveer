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
    
    case signUp(Parameters)
    case signIn(Parameters)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp,
             .signIn:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "user/signup"
        case .signIn:
            return "user/signin"
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
        case .signUp(let params),
             .signIn(let params):
            return try jsonEncoding.encode(urlRequest, with: params)
        }
    }
}

enum Router: BaseRouter {
    static var baseURLString: String?
    static var authToken: String?
    
    enum User {
        case create(Parameters)
        case user(identifier: String)
    }
    
    enum Group {
        case create(Parameters)
        case group(identifier: String)
    }
    
    case users(User)
    case groups(Group)
    case memberships(Parameters)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .users(.create),
             .groups(.create),
             .memberships:
            return .post
        case .groups(.group),
             .users(.user):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .users(.create):
            return "users"
        case .users(.user(let identifier)):
            return "users/\(identifier)"
            
        case .groups(.create):
            return "groups"
        case .groups(.group(let identifier)):
            return "groups/\(identifier)"
            
        case .memberships:
            return "memberships"
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
        case .users(.create(let params)):
            return try jsonEncoding.encode(urlRequest, with: params)
        case .users(.user):
            return try jsonEncoding.encode(urlRequest)
            
        case .groups(.create(let params)):
            return try jsonEncoding.encode(urlRequest, with: params)
        case .groups(.group):
            return try jsonEncoding.encode(urlRequest)
            
        case .memberships(let params):
            return try jsonEncoding.encode(urlRequest, with: params)
        }
    }
}
