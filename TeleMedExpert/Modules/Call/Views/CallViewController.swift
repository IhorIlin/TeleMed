//
//  CallViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import UIKit
import WebRTC

class CallViewController: UIViewController {
    private let viewModel: CallViewModel
    
    init(viewModel: CallViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impemented!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        
    }
    
    private func configureUI() {
        let renderer = RTCMTLVideoView(frame: self.view.frame)
        
        view.addSubview(renderer)
        
        viewModel.testStartCallPreview(in: renderer)
    }
    
    deinit {
        print("CallViewController deinited")
    }
}
