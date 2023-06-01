//
//  String+Extension.swift
//  OtakuVault
//
//  Created by Michael Bosworth on 5/22/23.
//

import Foundation

extension String {
    func filterMALAuthCode() -> String {
        guard let code = self.split(separator: "=").last else { return self }
        
        return String(code)
    }
}

extension URL? {
    func MALAuthCode() -> String {
        let urlString = self?.absoluteString
        guard let code = urlString?.split(separator: "=").last else { return "" }
        
        return String(code)
    }
}
