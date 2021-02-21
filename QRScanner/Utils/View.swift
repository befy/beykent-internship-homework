//
//  View.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

typealias LayoutableView = UIView & View

public protocol View: AnyObject {
    func setupViews()
    func setupLayout()
}

public extension View where Self: UIView {
    
    static func generate() -> Self {
        let view = Self()
        view.setupViews()
        view.setupLayout()
        return view
    }
    
}
