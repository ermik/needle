//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

import XCTest
@testable import NeedleFramework

class ExtensionsTests: AbstractParserTests {

    static var allTests = [
        ("test_urlInit_verifyIsFileURL", test_urlInit_verifyIsFileURL),
    ]

    private var filePath: String!
    private var dirPath: String!

    override func setUp() {
        super.setUp()

        filePath = "\(#file)"
        let index = filePath.lastIndex(of: "/")
        dirPath = String(filePath.prefix(upTo: index!))
    }

    func test_isDirectory_verifyResults() {
        XCTAssertFalse(filePath.isDirectory)
        XCTAssertTrue(dirPath.isDirectory)
    }

    func test_urlInit_verifyIsFileURL() {
        let fileUrl = URL(path: filePath)
        XCTAssertTrue(fileUrl.isFileURL)

        let dirUrl = URL(path: dirPath)
        XCTAssertFalse(dirUrl.isFileURL)
    }
}
