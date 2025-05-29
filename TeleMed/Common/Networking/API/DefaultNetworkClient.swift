//
//  DefaultNetworkClient.swift
//  TeleMed
//
//  Created by Ihor Ilin on 29.05.2025.
//

import Foundation
import Combine

final class DefaultNetworkClient: NetworkClient {
    func request<T>(endpoint: any Endpoint) -> AnyPublisher<T, NetworkClientError> where T: Decodable {
        var urlRequest = URLRequest(url: endpoint.url)
        
        urlRequest.httpMethod = endpoint.method
        urlRequest.httpBody = endpoint.body
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkClientError.unknown
                }
                
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkClientError.serverError(statusCode: response.statusCode, data: data)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? NetworkClientError {
                    return apiError
                } else if let decodingError = error as? DecodingError {
                    return .decodingFailed(decodingError)
                } else {
                    return .requestFailed(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
