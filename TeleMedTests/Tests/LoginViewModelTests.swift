//
//  LoginViewModelTests.swift
//  LoginViewModelTests
//
//  Created by Ihor Ilin on 10.05.2025.
//

import XCTest
import Combine
@testable import TeleMed

final class LoginViewModelTests: XCTestCase {
    private var viewModel: LoginViewModel!
    private var mockAuthClient: MockAuthClient!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockAuthClient = MockAuthClient()
        viewModel = LoginViewModel(authService: mockAuthClient)
    }

    override func tearDown() {
        viewModel = nil
        mockAuthClient = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFormValidation_WhenEmailAndPasswordAreValid_IsFormValidIsTrue() {
        viewModel.email = "test@example.com"
        viewModel.password = "Password1!"
        
        XCTAssertTrue(viewModel.isFormValid)
    }

    func testFormValidation_WhenEmailIsEmpty_IsFormValidIsFalse() {
        viewModel.email = ""
        viewModel.password = "Password1!"

        XCTAssertFalse(viewModel.isFormValid)
    }

    func testLogin_Success() {
        let expectation = expectation(description: "Login succeeds")
        mockAuthClient.loginResult = .success(.init(token: "dummy-token"))

        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockAuthClient.loginCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLogin_Failure() {
        let expectation = expectation(description: "Login fails")
        mockAuthClient.loginResult = .failure(NetworkClientError.serverError(statusCode: 401, data: Data()))

        viewModel.login()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockAuthClient.loginCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
