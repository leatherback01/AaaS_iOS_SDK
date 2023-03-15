//
//  LeatherBackTransactionParam.swift
//  LAAS
//
//  Created by Promise Ochornma on 03/03/2023.
//

import Foundation

public struct LeatherBackTransactionParam {
    // required parameters
    public var amount: Double
    public var currencyCode: Currency
    /// Your business' public key found at your dashboard
    public var key: String
    // the channel to accept payment from
    // if set to false, customerEmail and customerName must be provided
    public var showPersonalInformation: Bool
    // if set to true, use production key else use test key
    public var isProducEnv: Bool
    
    
    // optional parameters
    
    public var channels: [PaymentChannels]?
    /// You can generate a refrence for each transaction but it must be unique for payment to work
    public var reference: String?
    /// Customer's email
    public var customerEmail: String?
    /// Customer's name
    public var customerName: String?
    
    var formatttedParam: LeatherBackFormattedParam{
        
        return LeatherBackFormattedParam(amount: amount, currencyCode: currencyCode.rawValue, reference: getReferenceNumber(), customerEmail: customerEmail, customerName: customerName, key: key, showPersonalInformation: getShowInfoValue(), channels: getPaymentChannels())
    }
    
    
    
    public init(amount: Double, currencyCode: Currency,  channels: [PaymentChannels]? = nil, showPersonalInformation: Bool, reference: String? = nil, customerEmail: String? = nil, customerName: String? = nil, key: String, isProducEnv: Bool) {
        self.amount = amount
        self.currencyCode = currencyCode
        self.key = key
        self.showPersonalInformation = showPersonalInformation
        self.reference = reference
        self.customerEmail = customerEmail
        self.customerName = customerName
        self.isProducEnv = isProducEnv
        self.channels = channels
    }
    
    private func getShowInfoValue() -> Bool?{
        var pInfo:Bool? = nil
        if showPersonalInformation{
            pInfo = true
        }
        return pInfo
    }
    
    private func getReferenceNumber() -> String?{
        var theReference:String? = nil
        
        if let ref = reference{
            if !ref.isEmpty{
                theReference = ref
            }
        }
        return theReference
    }
    
    private func getPaymentChannels() -> [String]{
        var paymentChannel:[String] = []
        
        if let channel = channels{
            for cha in channel{
                if cha == .Card{
                    paymentChannel.append(PaymentChannelFormatted.Card.rawValue)
                }else{
                    paymentChannel.append(currencyCode == .NGN ? PaymentChannelFormatted.PayByTransfer.rawValue :  PaymentChannelFormatted.PayByAccount.rawValue)
                }
            }
        }else{
            
            paymentChannel = [PaymentChannelFormatted.Card.rawValue, currencyCode == .NGN ? PaymentChannelFormatted.PayByTransfer.rawValue :  PaymentChannelFormatted.PayByAccount.rawValue]
        }
        return paymentChannel
    }
}
