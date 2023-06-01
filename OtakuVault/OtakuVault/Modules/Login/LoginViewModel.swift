//
//  LoginViewModel.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/23/23.
//

import AuthenticationServices
import Combine
import Foundation

class LoginViewModel: NSObject, ObservableObject {
    // MARK: - Typealias
    typealias Depenedencies = HasMALAuthService & HasPKCEGenerator
    
    // MARK: - Wrapped Properties
    @Published var error: Error?
    
    // MARK: - Properties
    let dependencies: Depenedencies
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(dependencies: Depenedencies) {
        self.dependencies = dependencies
    }
    
    func getCode() {
        malWebLogin()
            .sink { [weak self] result in
                guard case .failure(let error) = result else { return }
                self?.error = error
            } receiveValue: { [weak self] authCode in
                guard let self = self else { return }
                let parameters = MalAuthParameters(code: authCode, codeVerifier: self.dependencies.pkceGenerator.codeVerifier)
                self.getAccessToken(using: parameters)
            }
            .store(in: &cancellables)

    }
    
    private func malWebLogin() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            guard let url = self.buildAuthURL() else {
                return promise(.failure(OVError.NetworkError.invalidURL))
            }
            
            let session = ASWebAuthenticationSession(url: url, callbackURLScheme: Constants.callbackURLScheme) { callbackURL, error in
                guard error == nil else {
                    return promise(.failure(error ?? OVError.NetworkResponseError.failed))
                }
                
                promise(.success(callbackURL.MALAuthCode()))
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            
            session.start()
        }
        .eraseToAnyPublisher()
    }
    
    private func getAccessToken(using parameters: MalAuthParameters) {
        dependencies
            .authService
            .getAuthCode(with: parameters)
            .sink { [weak self] result in
                guard case .failure(let error) = result else { return }
                self?.error = error
            } receiveValue: { response in
                print("accessToken response = \(response)")
            }
            .store(in: &cancellables)

    }
    
    private func buildAuthURL() -> URL? {
        dependencies.pkceGenerator.generateCode()
        
        let queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "code_challenge", value: dependencies.pkceGenerator.codeVerifier)
        ]
        
        guard let authURL = urlComponents(
            host: Constants.oauth2Host,
            path: Constants.oauth2Path,
            queryItems: queryItems).url else {
            return nil
        }
        
        return authURL
    }
    
    private func urlComponents(host: String, path: String, queryItems: [URLQueryItem]?) -> URLComponents {
        switch self {
        default:
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = queryItems
            return urlComponents
        }
    }
}

extension LoginViewModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

// MARK: - Dependencies
struct LoginDependencies: HasMALAuthService, HasPKCEGenerator {
    var authService: MALAuthServiceType = MALAuthService(provider: URLSessionProvider())
    var pkceGenerator: PKCEGeneratorType = PKCEGenerator()
}
