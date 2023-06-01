//
//  MALAuthTarget.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/19/23.
//

import Foundation

enum MALAuthTarget {
    case getAccessToken(parameters: MalAuthParameters)
}
 
extension MALAuthTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .getAccessToken:
            guard let url = URL(string: "https://myanimelist.net/v1") else {
              fatalError("Base URL Couldn't be Configured")
            }
            
            return url
        }
    }
    
    var path: String {
        switch self {
        case .getAccessToken:
            return "/oauth2/token"
        }
    }
    //https://myanimelist.net/v1/oauth2/token
    var method: HTTPMethod {
        switch self {
        case .getAccessToken:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getAccessToken(let authParameters):
            let parameters = [
                "client_id": "\(Constants.clientID)",
                "grant_type": "authorization_code",
                "code": "\(authParameters.code)",
                "code_verifier": "\(authParameters.codeVerifier)"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .getAccessToken(let malAuthParameters):
            return .basic(code: malAuthParameters.code)
        }
    }
}


struct MalAuthParameters: Codable {
//    let clientId: String
//    let grantType: String
    let code: String
    let codeVerifier: String
    
    enum CodingKeys: String, CodingKey {
//        case clientId = "client_id"
//        case grantType = "authorization_code"
        case code
        case codeVerifier = "code_verifier"
    }
}

struct Session: Codable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
