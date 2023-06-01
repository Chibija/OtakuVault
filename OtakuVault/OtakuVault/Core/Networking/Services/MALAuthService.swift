//
//  MALAuthService.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/19/23.
//

import Foundation
import Combine

protocol HasMALAuthService {
    var authService: MALAuthServiceType { get }
}

protocol MALAuthServiceType {
    func getAuthCode(with parameters: MalAuthParameters) -> AnyPublisher<Session, Error>
}

struct MALAuthService: MALAuthServiceType {
    let provider: NetworkProviderType
    
    init(provider: NetworkProviderType) {
        self.provider = provider
    }
    
    func getAuthCode(with parameters: MalAuthParameters) -> AnyPublisher<Session, Error> {
        provider.request(MALAuthTarget.getAccessToken(parameters: parameters))
    }
    
    
}
