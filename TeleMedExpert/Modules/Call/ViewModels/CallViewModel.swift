//
//  CallViewModel.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 30.06.2025.
//

import Combine
import Foundation
import WebRTC

final class CallViewModel: ObservableObject {
    enum Event {
        case callEnded
    }
    
    var publisher: AnyPublisher<Event, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private let subject = PassthroughSubject<Event, Never>()
    private var callEngine: CallEngine
    private let callConfiguration: CallConfiguration?
    
    weak var callEngineDelegate: CallEngineDelegate? {
        set {
            callEngine.delegate = newValue
        }
        get {
            callEngine.delegate
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(callEngine: CallEngine, callConfiguration: CallConfiguration?) {
        self.callEngine = callEngine
        self.callConfiguration = callConfiguration
        
        bindCallEngine()
    }
    
    func processCall() {
        if let config = callConfiguration {
            callEngine.startCall(config)
        }
    }
    
    private func bindCallEngine() {
        callEngine.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .callEnded:
                    self?.subject.send(.callEnded)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        print("CallViewModel deinited!")
    }
}

// MARK: - User actions -
extension CallViewModel {
    func acceptCall() {
        callEngine.acceptCall()
    }
    
    func endCall() {
        callEngine.endCall()
    }
    
    func declineCall() {
        callEngine.declineCall()
    }
    
    func manageMicrophone() {
        callEngine.onOffMicrophone()
    }
    
    func manageCamera() {
        callEngine.onOffCamera()
    }
    
    func switchCamera() {
        callEngine.switchCamera()
    }
}

