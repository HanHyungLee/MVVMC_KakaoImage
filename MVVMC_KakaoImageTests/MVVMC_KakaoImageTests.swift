//
//  MVVMC_KakaoImageTests.swift
//  MVVMC_KakaoImageTests
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import XCTest
@testable import MVVMC_KakaoImage

class MVVMC_KakaoImageTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        // test API
        callAPI()
    }
    
    func callAPI() {
        API.imageUrl(text: "Apple", page: 1, sort: .accuracy, size: 10).fetchImageList(RootModel.self) { result in
            switch result {
            case .success(let model):
                print("model = \(model)")
            case .failure(let error):
                print("error = \(error)")
            }
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
