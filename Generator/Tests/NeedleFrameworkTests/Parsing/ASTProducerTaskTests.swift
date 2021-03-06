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

import SourceKittenFramework
import XCTest
@testable import NeedleFramework

class ASTProducerTaskTests: AbstractParserTests {

    static var allTests = [
        ("test_execute_verifyNextTask", test_execute_verifyNextTask),
    ]

    func test_execute_verifyNextTask() {
        let sourceUrl = fixtureUrl(for: "ComponentSample.swift")
        let sourceContent = try! String(contentsOf: sourceUrl)
        let astContent = try! Structure(file: File(contents: sourceContent))

        let task = ASTProducerTask(sourceUrl: sourceUrl, sourceContent: sourceContent)
        let result = task.execute()

        XCTAssertEqual(result.structure, astContent)
        XCTAssertEqual(result.imports, ["import UIKit", "import RIBs", "import Foundation"])
    }
}
