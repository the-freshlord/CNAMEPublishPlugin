/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import Files
import Plot
import Publish
import XCTest

@testable import CNAMEPublishPlugin

// MARK: - TestWebsite

private struct TestWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case test
    }

    struct ItemMetadata: WebsiteItemMetadata {
    }
    
    var url = URL(string: "http://httpbin.org")!
    var name = "test"
    var description = ""
    var language: Language = .english
    var imagePath: Path? = nil
}

// MARK: - CNAMEPublishPluginTests

final class CNAMEPublishPluginTests: XCTestCase {
    
    // MARK: - Private Class Properties
    
    private static var testDirPath: Path {
        let sourceFileURL = URL(fileURLWithPath: #file)
        
        return Path(sourceFileURL.deletingLastPathComponent().path)
    }
    
    // MARK: - Internal Class Properties
    
    static var allTests = [
        ("testGeneratedCNAME_WithDomainNames", testGenerateCNAME),
        ("testGeneratedCNAME_WithFile", testAddCNAME)
    ]
    
    // MARK: - Private Instance Properties
    
    private var outputFolder: Folder? {
        try? Folder(path: Self.testDirPath.appendingComponent("Output").absoluteString)
    }
    
    private var resourcesFolder: Folder? {
        try? Folder(path: Self.testDirPath.absoluteString).createSubfolder(named: "Resources")
    }
    
    private var outputFile: File? {
        try? outputFolder?.file(named: "CNAME")
    }
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        try? outputFolder?.delete()
        try? resourcesFolder?.delete()
    }
    
    override func tearDown() {
        super.tearDown()
        
        try? outputFolder?.delete()
        try? resourcesFolder?.delete()
        try? Folder(path: Self.testDirPath.appendingComponent(".publish").absoluteString).delete()
    }
    
    // MARK: - Tests
    
    func testGenerateCNAME() throws {
        try TestWebsite().publish(at: Self.testDirPath, using: [
            .installPlugin(.generateCNAME(with: "test.io", "www.test.io"))
        ])
        
        let cnameOutput = try outputFile?.readAsString()
        
        XCTAssertEqual(cnameOutput, """
        test.io
        www.test.io
        """)
    }
    
    func testAddCNAME() throws {
        try resourcesFolder?
            .createFile(named: "CNAME")
            .write(["test.io", "www.test.io"].joined(separator: "\n"))
        
        try TestWebsite().publish(at: Self.testDirPath, using: [
            .installPlugin(.addCNAME())
        ])
        
        let cnameOutput = try outputFile?.readAsString()
        
        XCTAssertEqual(cnameOutput, """
        test.io
        www.test.io
        """)
    }
}
