//
//  WordCircleTests.swift
//  WordCircleTests
//
//  Created by Vamshi Krishna on 10/4/18.
//  Copyright © 2018 VamshiK. All rights reserved.
//

import XCTest
@testable import WordCircle

class WordCircleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUrlJsonData() {
        guard let Url = URL(string: "https://raw.githubusercontent.com/tmobil/WordCircle/master/english.json") else { return }
        let promise = expectation(description: "Simple Json Request")
        URLSession.shared.dataTask(with: Url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let result = json {
                    XCTAssertTrue(result["Abacination"] as! [String] == ["The act of abacinating."])
                    XCTAssertTrue(result["Abaculi"] as! [String] == ["of Abaculus"])
                    promise.fulfill()
                }
            } catch let err {
                print("Err", err)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetWordStartWith() {
        let vc = ViewController()
        let finalWord = vc.getWordStartWith("s", word: "sacra")
        XCTAssertNil(finalWord, "Should be nil")
    }
    
    func testIsWordValidFromDict()
    {
        let vc = ViewController()
        // before json was downloaded or words not found
        let valid = vc.isWordValidFromDict(word: "Act")
        XCTAssertFalse(valid)
        
    }
}
