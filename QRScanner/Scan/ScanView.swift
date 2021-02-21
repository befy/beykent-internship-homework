//
//  ScanView.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

final class ScanView: LayoutableView {
    
    private (set) lazy var previewView = ScanPreviewView()
    private lazy var markView = ScanMarkView()

    
    func setupViews() {
        backgroundColor = .black
        previewView.translatesAutoresizingMaskIntoConstraints = false
        markView.translatesAutoresizingMaskIntoConstraints = false
        add(previewView, markView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            markView.centerXAnchor.constraint(equalTo: centerXAnchor),
            markView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
