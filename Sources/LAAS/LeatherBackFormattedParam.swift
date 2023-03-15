//
//  LeatherBackFormattedParam.swift
//  LAAS
//
//  Created by Promise Ochornma on 06/03/2023.
//

import Foundation

 struct LeatherBackFormattedParam: Codable {
    public var amount: Double
    public var currencyCode: String
    public var key: String
    public var reference: String?
    public var customerEmail: String?
    public var customerName: String?
    public var showPersonalInformation: Bool?
    public var applicationMode: String
    public var channels: [String]
    
    
    init(amount: Double, currencyCode: String, reference: String? = nil, customerEmail: String? = nil, customerName: String? = nil, key: String, showPersonalInformation: Bool?, applicationMode: String = "mobile", channels: [String]) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.key = key
        self.reference = reference
        self.customerEmail = customerEmail
        self.customerName = customerName
        self.showPersonalInformation = showPersonalInformation
        self.applicationMode = applicationMode
        self.channels = channels
    }
    
    func convertCodableToString() -> String?{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else{
            return nil
        }
        let dataString = String(data: data, encoding: .utf8)
        return dataString
    }
}
