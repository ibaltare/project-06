//
//  HomeViewModelTest.swift
//  HeroMapTests
//
//  Created by Nicolas on 01/10/22.
//

import XCTest
import KeychainSwift
@testable import HeroMap

final class HomeViewModelTest: XCTestCase {

    //System under testing
    var sut: HomeViewModel!
    var networkServiceMock: NetworkServiceMock!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        networkServiceMock = nil
    }

    func testLoadHeroesSuccess() throws {
        networkServiceMock = NetworkServiceMock()
        networkServiceMock.heroData = NetworkServiceMock.heroData
        networkServiceMock.locationData = NetworkServiceMock.locationData
        sut = HomeViewModel(networkService: networkServiceMock)
        let expectation = expectation(description: "DispatchGroup finalized")
        var success = false
        var message = "Test load heroes"
        sut.onError = { error in
            message = error
            expectation.fulfill()
        }
        sut.onSuccessLoad = {
            success = true
            expectation.fulfill()
        }
        sut.signOut()
        KeychainSwift().set("token", forKey: KeyChain.token.rawValue)
        sut.loadHeroes()
        waitForExpectations(timeout: 5)
        XCTAssertTrue(success,message)
    }
    
    func testLoadHeroesFailWithNotData() throws {
        networkServiceMock = NetworkServiceMock()
        sut = HomeViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Test load heroes fail with not data"
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccessLoad = { }
        sut.signOut()
        KeychainSwift().set("token", forKey: KeyChain.token.rawValue)
        sut.loadHeroes()
        XCTAssertTrue(success,message)
    }
    
    func testLoadHeroesFailWithNotToken() throws {
        networkServiceMock = NetworkServiceMock()
        sut = HomeViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Test load heroes fail whit not token"
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccessLoad = { }
        sut.signOut()
        sut.loadHeroes()
        XCTAssertTrue(success,message)
    }
    
    func testSearchHeroByName() throws {
        networkServiceMock = NetworkServiceMock()
        sut = HomeViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Test Search Hero"
        sut.onError = { error in
            message = error
        }
        sut.onSuccessLoad = {
            success = true
        }
        sut.searchHero(by: "Go")
        XCTAssertTrue(success,message)
    }
    
    func testSearchHeroByEmptyName() throws {
        networkServiceMock = NetworkServiceMock()
        sut = HomeViewModel(networkService: networkServiceMock)
        var success = false
        var message = "Test Search Hero by empty name"
        sut.onError = { error in
            message = error
        }
        sut.onSuccessLoad = {
            success = true
        }
        sut.searchHero(by: "")
        XCTAssertTrue(success,message)
    }

}
