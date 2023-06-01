//
//  PKCEGenerator.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/21/23.
//

import Foundation

protocol HasPKCEGenerator {
    var pkceGenerator: PKCEGeneratorType { get }
}

protocol PKCEGeneratorType {
    var codeVerifier: String { get }
    var codeChallenge: String { get }
    func generateCode()
    func generateCodeVerifier()
    func generateCodeChallenge(from codeVerifier: String)
}

class PKCEGenerator: PKCEGeneratorType {
    var codeVerifier: String = ""
    var codeChallenge: String = ""
    
    func generateCode(){
        generateCodeVerifier()
        generateCodeChallenge(from: codeVerifier)
    }
    
    func generateCodeVerifier() {
        let fullCharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let charsetLength = fullCharset.count
        
        var verifier = ""
        let randomLength = Int.random(in: 43...128)
        
        for _ in 0..<randomLength {
            let randomIndex = Int.random(in: 0..<charsetLength)
            let randomCharacter = fullCharset[fullCharset.index(fullCharset.startIndex, offsetBy: randomIndex)]
            verifier.append(randomCharacter)
        }
        codeVerifier = verifier
    }
    
    func generateCodeChallenge(from codeVerifier: String) {
        let verifierData = codeVerifier.data(using: .utf8)!
        let base64EncodedVerifier = verifierData.base64EncodedString(options: [])
        
        let codeChallengeData = base64EncodedVerifier
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .data(using: .utf8)!
        
        let codeChallenge = codeChallengeData.base64EncodedString(options: [])
        
        self.codeChallenge = codeChallenge
    }
}
