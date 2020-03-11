/**
*  CNAME file generator plugin for Publish
*  Copyright (c) Manny Guerrero 2020
*  MIT license, see LICENSE file for details
*/

import Files
import Foundation
import Publish

// MARK: - CNAME_Error

/// Supported errors that can occur with CNAME file generation.
public enum CNAME_Error: LocalizedError {
    
    /// The list of provided domain names is empty.
    case listEmpty
    
    /// In the list of provided domain names, there is an empty string.
    case containsEmptyString
    
    public var localizedDescription: String {
        switch self {
        case .listEmpty:
            return "The provided list of domain names are empty. At least one domain name is required for file generation."
        case .containsEmptyString:
            return "One of the provided domain names is an empty string."
        }
    }
}

// MARK: - Plugin

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
    
    static func generateCNAME(with domainNames: [String]) -> Self {
        Plugin(name: "Generate CNAME from provided domain names") { context in
            guard domainNames.allSatisfy({ !$0.isEmpty }) else { return }
        }
    }
    
    /// Returns a plugin that copies a custom domain name file from the website's resources directory to the website's
    /// output directory.
    static func addCNAME() -> Self {
        Plugin(name: "Generate CNAME from existing CNAME file in the Resources directory") { context in
            let file = try context.file(at: "Resources/CNAME")
            
            let fileContent = try file.readAsString()
            
            guard !fileContent.isEmpty else { return }
            
            try context.copyFileToOutput(from: "Resources/CNAME")
        }
    }
}
