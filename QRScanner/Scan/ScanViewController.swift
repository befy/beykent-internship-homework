//
//  ScanViewController.swift
//  QRScanner
//
//  Created by Alper Tabak on 21.02.2021.
//

import UIKit

class ScanViewController: ViewController<ScanView> {
    
    
    private let viewModel: ScanViewModel
    
    public required init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.isEligibleToScan = true
        viewModel.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.isEligibleToScan = false
        viewModel.stopSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        requestAccessIfAppropriate()
        layoutableView.previewView.setSession(session: viewModel.session)
    }
    
    private func requestAccessIfAppropriate() {
        guard !viewModel.hasInitialSetupDone else { return }
        
        switch viewModel.authorizationStatus {
        case .authorized:
            self.viewModel.setupSession()
        case .notDetermined:
            self.viewModel.requestAccess { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.viewModel.setupSession()
                    }
                }
            }
        case .denied:
            break
        default:
            debugPrint("Unknown authorization status")
        }
    }
}

extension ScanViewController: ScanViewModelDelegate {
    
    func scanViewModel(_ viewModel: ScanViewModel, didOutput readableCodePayload: String) {
        
        guard let url = URL(string: readableCodePayload) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            viewModel.isEligibleToScan = true
            self.viewModel.startSession()
        }
        
    }
    
}
