//
//  QRCodeType.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

public enum QRCodeType: String, CaseIterable {
    case text
    case website
    case sms
    case phone
    case email
    case facebook
    case instagram
    case twitter
    case whatsApp
    
    /// Returns the name of type.
    public var name: String {
        switch self {
        case .text:
            return "Metin"
        case .website:
            return "Website"
        case .sms:
            return "SMS"
        case .phone:
            return "Telefon Numarası"
        case .email:
            return "E-posta"
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        case .twitter:
            return "Twitter"
        case .whatsApp:
            return "Whatsapp"
        }
    }
    
}

extension QRCodeType: RawRepresentable {
    
    public typealias RawValue = String
    
    public init(rawValue: RawValue) {
        switch rawValue {
        case "website":
            self = .website
        case "sms":
            self = .sms
        case "phone":
            self = .phone
        case "email":
            self = .email
        case "facebook":
            self = .facebook
        case "instagram":
            self = .instagram
        case "twitter":
            self = .twitter
        case "whatsApp":
            self = .whatsApp
        default:
            self = .text
        }
    }
    
}
