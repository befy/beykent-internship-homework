//
//  ScanPreviewView.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import AVFoundation

final internal class ScanPreviewView: LayoutableView {
    
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    
    private var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    private var session: AVCaptureSession? {
        didSet {
            if let session = session {
                self.previewLayer.session = session
                self.previewLayer.videoGravity = .resizeAspectFill
            }
        }
    }
    
    public func setSession(session: AVCaptureSession) {
        self.session = session
    }
    
    func setupViews() {}
    func setupLayout() {}
}
