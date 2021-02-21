//
//  Extensions.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import Foundation
import UIKit
import AVFoundation

extension UIView {
    
    func add(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
}

extension UIImageView {
    
    convenience init(image: UIImage? = nil,
                     contentMode: UIView.ContentMode = .scaleAspectFit) {
        
        self.init()
        self.contentMode = contentMode
        self.image = image
    }
    
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF,
                  green: (hex >> 8) & 0xFF,
                  blue: hex & 0xFF)
    }
}

extension AVCaptureMetadataOutput {
    
    /// Returns `AVMetadataObject.ObjectType`s to handle QR codes.
    public var qrCodeTypes: [AVMetadataObject.ObjectType] {
        return [
            .aztec,
            .qr,
            .code39,
            .code39Mod43,
            .dataMatrix,
            .ean13,
            .ean8,
            .itf14,
            .pdf417,
            .interleaved2of5,
            .upce
        ]
    }
    
}

