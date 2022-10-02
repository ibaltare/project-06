//
//  MapViewModelTest.swift
//  HeroMapTests
//
//  Created by Nicolas on 02/10/22.
//

import XCTest
@testable import HeroMap

final class MapViewModelTest: XCTestCase {

    //System under testing
    var sut: MapViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testLoadLocationFailNotHero() throws {
        sut = MapViewModel()
        var success = false
        var message = "Test load locations fail not hero"
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccess = { }
        sut.loadLocations(for: HeroMock.heroNotFound)
        XCTAssertTrue(success,message)
    }
    
    func testLoadLocationFailNotLocation() throws {
        sut = MapViewModel()
        var success = false
        var message = "Test load locations fail not location"
        try CoreDataManager.shared.deleteAll()
        try CoreDataManager.shared.save(heroes: [HeroMock.heroTest])
        sut.onError = { error in
            message = error
            success = true
        }
        sut.onSuccess = { }
        sut.loadLocations(for: HeroMock.heroTest)
        XCTAssertTrue(success,message)
    }
    
    func testLoadLocationSuccess() throws {
        sut = MapViewModel()
        var success = false
        var message = "Test load locations success"
        try CoreDataManager.shared.save(heroes: [HeroMock.heroTest])
        let eHero = try CoreDataManager.shared.fetchHeroes(by: "name CONTAINS[c] %@", with: "Goku")
        try CoreDataManager.shared.save(locations: [HeroMock.heroLocationTest], eHero: eHero.first!)
        let expectation = expectation(description: "DispatchGroup finalized")
        sut.onError = { error in
            message = error
            expectation.fulfill()
        }
        sut.onSuccess = {
            success = true
            expectation.fulfill()
        }
        sut.loadLocations(for: HeroMock.heroTest)
        waitForExpectations(timeout: 5)
        XCTAssertTrue(success,message)
    }

}
