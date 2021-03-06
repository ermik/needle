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

/// The set of errors may be thrown by the `FileEnumerator`.
enum FileEnumerationError: Error {
    /// Failed to read the text file that is supposed to contain a list
    /// of paths on each line.
    case failedToReadSourcesList(URL, Error)
    /// Failed to traverse a directory specified by given URL.
    case failedToTraverseDirectory(URL)
}

/// A utility class that provides file enumeration from a root directory.
class FileEnumerator {

    /// Enumerate all the files in the root URL. If the given URL is a
    /// directory, it is traversed recursively to surface all file URLs.
    /// If the given URL is a file, it is treated as a text file where
    /// each line is assumed to be a path to a file.
    ///
    /// - parameter rootUrl: The root URL to enumerate from.
    /// - parameter handler: The closure to invoke when a file URL is found.
    /// - throws: `FileEnumerationError` if any errors occurred.
    func enumerate(from rootUrl: URL, handler: (URL) -> Void) throws {
        if rootUrl.isFileURL {
            let fileUrls = try self.fileUrls(fromSourcesList: rootUrl)
            for fileUrl in fileUrls {
                handler(fileUrl)
            }
        } else {
            let enumerator = try newFileEnumerator(for: rootUrl)
            while let nextObjc = enumerator.nextObject() {
                if let fileUrl = nextObjc as? URL {
                    handler(fileUrl)
                }
            }
        }
    }

    // MARK: - Private

    private func fileUrls(fromSourcesList listUrl: URL) throws -> [URL] {
        do {
            let content = try String(contentsOf: listUrl)
            let paths = content
                .split(separator: "\n")
                .compactMap { (substring: Substring) -> String? in
                    let string = String(substring).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    return string.isEmpty ? nil : string
                }
                .map { (path: String) -> URL in
                    URL(fileURLWithPath: path)
                }
            return paths
        } catch {
            throw FileEnumerationError.failedToReadSourcesList(listUrl, error)
        }
    }

    private func newFileEnumerator(for rootUrl: URL) throws -> FileManager.DirectoryEnumerator {
        let errorHandler = { (url: URL, error: Error) -> Bool in
            fatalError("Failed to traverse \(url) with error \(error).")
        }
        if let enumerator = FileManager.default.enumerator(at: rootUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles], errorHandler: errorHandler) {
            return enumerator
        } else {
            throw FileEnumerationError.failedToTraverseDirectory(rootUrl)
        }
    }
}
