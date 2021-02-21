//
//  ScanMarkView.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

final internal class ScanMarkView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView = UIImageView(
        image: UIImage(named :"scan-mark"),
        contentMode: .scaleAspectFill
    )
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xf39a6b)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    func setupViews() {
        imageView.clipsToBounds = true
        imageView.addSubview(lineView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        animateLineView()
        addSubview(imageView)
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 48),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            lineView.heightAnchor.constraint(equalToConstant: 10)
        ])
        
    }
    
    private func animateLineView() {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.byValue = 170
        animation.fillMode = .forwards
        animation.repeatCount = .infinity
        animation.duration = 1
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        lineView.layer.add(animation, forKey: "positionAnimation")
    }
}
