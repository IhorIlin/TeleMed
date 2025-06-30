//
//  CallViewController.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import UIKit
import WebRTC
import SnapKit

class CallViewController: UIViewController {
    private let videoPreview = UIView()
    private let viewModel: CallViewModel
    private let renderer = RTCMTLVideoView()
    
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
        view.backgroundColor = ColorPalette.Background.secondary
        configureVideoPreview()
        configureRenderer()
        
        viewModel.testStartCallPreview(in: renderer)
    }
    
    private func configureVideoPreview() {
        view.addSubview(videoPreview)
        
        videoPreview.translatesAutoresizingMaskIntoConstraints = false
        
        videoPreview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(200)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(100)
            make.height.equalTo(200)
        }
    }
    
    private func configureRenderer() {
        videoPreview.addSubview(renderer)
        
        renderer.translatesAutoresizingMaskIntoConstraints = false
        
        renderer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    deinit {
        print("CallViewController deinited")
    }
}
