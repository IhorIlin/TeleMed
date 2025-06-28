//
//  PushRegistryManaging.swift
//  TeleMedExpert
//
//  Created by Ihor Ilin on 28.06.2025.
//

import PushKit

protocol PushRegistryManaging {
    var delegate: PKPushRegistryDelegate? { get set }
    var desiredPushTypes: Set<PKPushType>? { get set }
}
