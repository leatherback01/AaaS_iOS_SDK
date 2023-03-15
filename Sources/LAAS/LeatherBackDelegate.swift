//
//  LeatherBackDelegate.swift
//  LAAS
//
//  Created by Promise Ochornma on 03/03/2023.
//

import Foundation
import UIKit

public protocol LeatherBackDelegate{
    func onLeatherBackError(error: LeatherBackErrorResponse)
    func onLeatherBackSuccess(response: LeatherBackResponse)
    func onLeatherBackDimissal()
}

extension UIImage {
    class func resourceImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: LeatherBackViewController.classForCoder()), compatibleWith: nil)
        }
        return image
    }
}

extension String{
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func convertDataToString() -> String?{
        let utf8str = self.data(using: .utf8)
        
        if let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) {
            return base64Encoded
        }
        return nil
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            print("the query name \(item.name)")
            result[item.name] = item.value
        }
    }
}


