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
    private let topContainerView = UIView()
    private let callerNameLabel = UILabel()
    private let callTimeLabel = UILabel()
    
    private let remoteVideoView = UIView()
    private let localVideoContainer = UIView()
    private let localVideoView = RTCMTLVideoView()
    
    private let bottomContainerView = UIView()
    private let bottomStackView = UIStackView()
    private let acceptCallButton = UIButton(type: .system)
    private let declineCallButton = UIButton(type: .system)
    private let cameraButton = UIButton(type: .system)
    private let microphoneButton = UIButton(type: .system)
    
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
        
        viewModel.initiateCall()
    }
    
    private func configureUI() {
        view.backgroundColor = ColorPalette.CallScreen.background
        
        configurelocalVideoContainer()
        configurelocalVideoView()
        configureRemoteVideoView()
        configureTopContainerView()
        configureCallerNameLabel()
        configureCallTimeLabel()
        configureBottomContainerView()
        configureMicrophoneButton()
        configureAcceptCallButton()
        configureDeclineCallButton()
        configureCameraButton()
        configureBottomStackView()
        
        viewModel.testStartCallPreview(in: localVideoView)
    }
    
    private func configurelocalVideoContainer() {
        view.addSubview(localVideoContainer)
        
        localVideoContainer.translatesAutoresizingMaskIntoConstraints = false
        localVideoContainer.layer.cornerRadius = 8
        localVideoContainer.layer.masksToBounds = true
        
        localVideoContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(170)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(120)
            make.height.equalTo(200)
        }
    }
    
    private func configurelocalVideoView() {
        localVideoContainer.addSubview(localVideoView)
        
        localVideoView.translatesAutoresizingMaskIntoConstraints = false
        
        localVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRemoteVideoView() {
        view.addSubview(remoteVideoView)
        
        remoteVideoView.translatesAutoresizingMaskIntoConstraints = false
        
        remoteVideoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureTopContainerView() {
        view.addSubview(topContainerView)
        
        topContainerView.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(75)
        }
    }
    
    private func configureCallerNameLabel() {
        topContainerView.addSubview(callerNameLabel)
        
        callerNameLabel.font = Font.TextStyle.titleMedium()
        callerNameLabel.text = "Ihor Ilin"
        callerNameLabel.textColor = ColorPalette.Text.primary
        
        callerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        callerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureCallTimeLabel() {
        topContainerView.addSubview(callTimeLabel)
        
        callTimeLabel.font = Font.TextStyle.caption()
        callTimeLabel.text = "00:03"
        callTimeLabel.textColor = ColorPalette.Text.primary
        
        callTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        callTimeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureBottomContainerView() {
        view.addSubview(bottomContainerView)
        
        bottomContainerView.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    private func configureMicrophoneButton() {
        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        microphoneButton.layer.cornerRadius = 30
        microphoneButton.layer.masksToBounds = true
        microphoneButton.tintColor = .white
        microphoneButton.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        microphoneButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    
    private func configureAcceptCallButton() {
        acceptCallButton.translatesAutoresizingMaskIntoConstraints = false
        
        acceptCallButton.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        
        acceptCallButton.layer.cornerRadius = 30
        acceptCallButton.layer.masksToBounds = true
        acceptCallButton.tintColor = .green
        acceptCallButton.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        acceptCallButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    
    private func configureDeclineCallButton() {
        declineCallButton.translatesAutoresizingMaskIntoConstraints = false
        
        declineCallButton.setImage(UIImage(systemName: "phone.down.fill"), for: .normal)
        declineCallButton.addTarget(self, action: #selector(endCallButtonPressed(sender:)), for: .touchUpInside)
        
        declineCallButton.layer.cornerRadius = 30
        declineCallButton.layer.masksToBounds = true
        declineCallButton.tintColor = .red
        declineCallButton.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        declineCallButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    
    private func configureCameraButton() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.setImage(UIImage(systemName: "camera.rotate.fill"), for: .normal)
        
        cameraButton.layer.cornerRadius = 30
        cameraButton.layer.masksToBounds = true
        cameraButton.tintColor = .white
        cameraButton.backgroundColor = ColorPalette.CallScreen.containerBackground
        
        cameraButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    
    private func configureBottomStackView() {
        bottomContainerView.addSubview(bottomStackView)
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomStackView.addArrangedSubview(microphoneButton)
        bottomStackView.addArrangedSubview(acceptCallButton)
        bottomStackView.addArrangedSubview(declineCallButton)
        bottomStackView.addArrangedSubview(cameraButton)
        
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .center
        bottomStackView.distribution = .equalSpacing
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70)
        }
    }
    
    @objc func endCallButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    deinit {
        print("CallViewController deinited")
    }
}
