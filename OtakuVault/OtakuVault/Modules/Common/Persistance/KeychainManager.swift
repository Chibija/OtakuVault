//
//  KeychainManager.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/24/23.
//

import SwiftKeychainWrapper

struct KeychainManager {
    enum KeychainKeys {
        case session
    }
    
    static var shared: KeychainManager = KeychainManager()
    
    private init() {}
    
    func test() {
        
    }
}
