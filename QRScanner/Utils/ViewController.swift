//
//  ViewController.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

typealias LayoutingViewController = UIViewController & Layouting

public protocol Layouting: AnyObject {
    
    associatedtype ViewType: UIView & View
    
    var layoutableView: ViewType { get }
    
}

public extension Layouting where Self: UIViewController {
    
    var layoutableView: ViewType {
        guard let aView = view as? ViewType else {
            fatalError("view property has not been inialized yet, or not initialized as \(ViewType.self).")
        }
        return aView
    }
    
}

class ViewController<V: LayoutableView>: LayoutingViewController {
    
    typealias ViewType = V
    
    override func loadView() {
        super.loadView()
        self.view = V.generate()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
