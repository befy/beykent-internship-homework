//
//  ScanViewModel.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import AVFoundation
import UIKit
import Vision

internal protocol ScanViewModelProtocol: class {
    typealias BarcodeRequestHandler = (Result<VNBarcodeObservation, Error>) -> Void
    
    typealias RequestAccessHandler = (Bool) -> Void
    
    var delegate: ScanViewModelDelegate? { get }
    
    var hasInitialSetupDone: Bool { get }
    
    var authorizationStatus: AVAuthorizationStatus { get }
    
    var session: AVCaptureSession { get }
    
    var isEligibleToScan: Bool { get set }
    
    func setupSession()
    
    func startSession()
    
    func stopSession()
    
    func requestAccess(_ handler: @escaping RequestAccessHandler)
    
    func scanBarcodeFromImage(_ image: UIImage, handler: @escaping BarcodeRequestHandler) throws
    
    func saveQR(_ payload: String, type: QRCodeType)
}

internal protocol ScanViewModelDelegate: class {
    func scanViewModel(_ viewModel: ScanViewModel, didOutput readableCodePayload: String)
    //func scanViewModel(_ viewModel: ScanViewModel, didSave qrCode: QRCode)
}

final internal class ScanViewModel: NSObject, ScanViewModelProtocol {
    func saveQR(_ payload: String, type: QRCodeType) {
        
    }
    
    public typealias BarcodeRequestHandler = (Result<VNBarcodeObservation, Error>) -> Void
    
    weak var delegate: ScanViewModelDelegate?
    
    // Metadata outputs will be fired frequently. So, we should catch them in the background thread.
    private let callbackQueue = DispatchQueue(label: "com.mobileware.qrscanner.captureQueue", qos: .background)
    
    // Session related actions will be handled with the session queue.
    private let sessionQueue = DispatchQueue(label: "com.mobileware.qrscanner.sessionQueue", qos: .userInteractive)
    
    private (set) var session = AVCaptureSession()
    
    private var isRunning: Bool { session.isRunning }
    
    private var captureDevice: AVCaptureDevice? { .default(for: .video) }
    
    public var authorizationStatus: AVAuthorizationStatus { AVCaptureDevice.authorizationStatus(for: .video) }
    
    public var hasInitialSetupDone: Bool = false
    
    public var canPresentInitialPaywall: Bool = true
    
    public var isEligibleToScan: Bool = true
    
    /// Setups the session initially.
    func setupSession() {
        guard let captureDevice = self.captureDevice else {
            debugPrint("Could not find capture device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            debugPrint("Could not create device input", error)
            return
        }
        
        guard self.session.canAddInput(videoInput) else {
            debugPrint("This device is not allowed to add an input")
            self.session.commitConfiguration()
            return
        }
        
        self.session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        guard self.session.canAddOutput(metadataOutput) else {
            debugPrint("This device is not allowed to add an output")
            self.session.commitConfiguration()
            return
        }
        
        self.session.addOutput(metadataOutput)
        
        metadataOutput.metadataObjectTypes = metadataOutput.qrCodeTypes
        metadataOutput.setMetadataObjectsDelegate(self, queue: self.callbackQueue)
        
        hasInitialSetupDone = true
    }
    
    /// Starts the capture session.
    func startSession() {
        guard !isRunning else { return }
        
        self.sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    /// Stops the capture session.
    func stopSession() {
        guard isRunning else { return }
        
        self.sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    func requestAccess(_ handler: @escaping RequestAccessHandler) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: handler)
    }
    
    /// Scans the barcode from the image and fires the first observation through the handler.
    ///
    /// - Parameters:
    ///   - image: UIImage.
    ///   - handler: BarcodeRequestHandler.
    func scanBarcodeFromImage(_ image: UIImage, handler: @escaping BarcodeRequestHandler) throws {
        guard let cgImage = image.cgImage else { return }
        
        let barcodeRequest = VNDetectBarcodesRequest { (request, error) in
            if let error = error {
                handler(.failure(error))
            } else if let result = request.results?.first as? VNBarcodeObservation {
                handler(.success(result))
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([barcodeRequest])
    }
    
}

extension ScanViewModel: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection) {
        self.stopSession()
        guard self.isEligibleToScan,
              let metadataObject = metadataObjects.first else { return }
        
        if let readableCodeObject = metadataObject as? AVMetadataMachineReadableCodeObject {
            if let payload = readableCodeObject.stringValue {
                
                DispatchQueue.main.async {
                    self.delegate?.scanViewModel(self, didOutput: payload)
                    print(payload)
                }
                
            }
        }
    }
    
}
