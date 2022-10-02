//
//  LoginViewModelTest.swift
//  HeroMapTests
//
//  Created by Nicolas on 01/10/22.
//

import XCTest
@testable import HeroMap

final class LoginViewModelTest: XCTestCase {

    //System under testing
    var sut: LoginViewModel!
    var networkServiceMock: NetworkServiceMock!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        networkServiceMock = nil
    }

    func testLoginFailWithNotData() throws {
        networkServiceMock = NetworkServiceMock(simpleResult: .failure(.noData))
        sut = LoginViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Login fail with not data"
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccess = {
            success = false
        }
        sut.login(with: "test", password: "test")
        XCTAssertTrue(success,message)
    }
    
    func testLoginFailNotAuthenticated() throws {
        networkServiceMock = NetworkServiceMock(simpleResult: .failure(.notAuthenticated))
        sut = LoginViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Login Fail Not Authenticated"
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccess = {
            success = false
        }
        sut.login(with: "test", password: "test")
        XCTAssertTrue(success,message)
    }

    func testLoginSuccess() throws {
        var success = false
        networkServiceMock = NetworkServiceMock(simpleResult: .success("token"))
        sut = LoginViewModel(networkService: networkServiceMock)
        sut.onSuccess = {
            success = true
        }
        sut.login(with: "test", password: "test")
        XCTAssertTrue(success)
    }

}
