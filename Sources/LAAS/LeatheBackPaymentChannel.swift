//
//  LeatheBackPaymentChannel.swift
//  LAAS
//
//  Created by Promise Ochornma on 14/03/2023.
//

import Foundation

public enum PaymentChannels {
    case Card
    case Account
    
}

public enum PaymentChannelFormatted: String {
    case Card = "Card"
    case PayByTransfer = "PayByTransfer"
    case PayByAccount = "PayByAccount"
    
}
