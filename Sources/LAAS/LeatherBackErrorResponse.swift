//
//  LeatherBackErrorResponse.swift
//  LAAS
//
//  Created by Promise Ochornma on 10/03/2023.
//

import Foundation

public struct LeatherBackErrorResponse: Error, CustomStringConvertible {
    public var description: String {return message}
    let message: String
    static let genericError = LeatherBackErrorResponse(message: "Error in processing your payment")
    enum CodingKeys: String, CodingKey {
        case message
    }
}



extension LeatherBackErrorResponse: LocalizedError {
    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
