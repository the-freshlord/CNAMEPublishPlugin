/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import Files
import Publish

public extension Plugin {
    
    /// Returns a plugin that creates a custom domain name file from a list of domain names and adds it to the website's
    /// output directory.
    ///
    /// - Parameter domainNames: A list of domain names to use for the website.
    static func generateCNAME(with domainName: String, _ otherDomainNames: String...) -> Self {
        Plugin(name: "Generate CNAME for custom domain names") { context in
            let allDomainNames = CollectionOfOne(domainName) + otherDomainNames
            
            let fileContent = allDomainNames.joined(separator: "\n")
            
            try context.createOutputFile(at: "CNAME").write(fileContent)
        }
    }
    
    /// Returns a plugin that copies a custom domain name file from the website's resources directory to the website's
    /// output directory.
    static func addCNAME() -> Self {
        Plugin(name: "Generate CNAME for custom domain names") { context in
            let file = try context.file(at: "Resources/CNAME")
            
            let fileContent = try file.readAsString()
            
            guard !fileContent.isEmpty else { return }
            
            try context.copyFileToOutput(from: "Resources/CNAME")
        }
    }
}
