//
//  APIService.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

protocol APIService {
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, Error> 
}
