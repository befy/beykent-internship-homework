//
//  QRCodeParser.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import Foundation

internal protocol QRCodeParserProtocol: class {
    static func parse(payload: String) -> QRCodeType
}

final internal class QRCodeParser: QRCodeParserProtocol {
    
    public static func parse(payload: String) -> QRCodeType {
        let matchPattern = "^((http|https|tel|sms|mailto|fb|instagram|whatsapp|twitter):(//)?)"
        
        guard let range = payload.range(of: matchPattern, options: .regularExpression) else {
            return .text
        }
        
        switch payload[range] {
        case "http://", "https://":
            return .website
        case "tel:", "tel://":
            return .phone
        case "sms:", "sms://":
            return .sms
        case "mailto:", "mailto://":
            return .email
        case "fb:", "fb://":
            return .facebook
        case "instagram:", "instagram://":
            return .instagram
        case "whatsapp:", "whatsapp://":
            return .whatsApp
        case "twitter:", "twitter://":
            return .twitter
        default:
            return .text
        }
    }
}
