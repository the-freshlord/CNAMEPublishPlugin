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
enum CNAMEGenerationError: LocalizedError, CustomStringConvertible {
    
    /// The list of provided domain names is empty.
    case listEmpty
    
    /// In the list of provided domain names, there is an empty string.
    case containsEmptyString
    
    var description: String {
        switch self {
        case .listEmpty:
            return "The provided list of domain names are empty. At least one domain name is required for file generation."
        case .containsEmptyString:
            return "One of the provided domain names is an empty string."
        }
    }
    
    var localizedDescription: String { description }
    var errorDescription: String? { description }
}

// MARK: - Plugin

public extension Plugin {
    
    /// Returns a plugin that creates a custom domain name file from a given domain name as well as a list of other
    /// domain names and adds it to the website's output directory.
    ///
    /// - Parameters:
    ///   - domainName: The domain name that will be first in the file.
    ///   - otherDomainNames: A list of other domain names that will come after `domainName`.
    ///
    /// - Throws: See [generateCNAME(with domainNames: [String])](x-source-tag://throwingMethod) for errors that can be
    ///           thrown.
    static func generateCNAME(with domainName: String, _ otherDomainNames: String...) -> Self {
        return generateCNAME(with: CollectionOfOne(domainName) + otherDomainNames)
    }
    
    /// Returns a plugin that creates a custom domain name file from a list of domain names and adds it to the website's
    /// output directory.
    ///
    /// - Tag: throwingMethod
    ///
    /// - Parameter domainNames: A list of domain names to use for the website.
    ///
    /// - Throws:
    ///      - `CNAMEGenerationError.listEmpty` if the provided list is empty.
    ///      - `CNAMEGenerationError.containsEmptyString` if one or more of the provided domain names are empty strings.
    static func generateCNAME(with domainNames: [String]) -> Self {
        Plugin(name: "Generate CNAME from provided domain names") { context in
            guard !domainNames.isEmpty else { throw CNAMEGenerationError.listEmpty }
            
            guard domainNames.allSatisfy({ !$0.isEmpty }) else { throw CNAMEGenerationError.containsEmptyString }
            
            let fileContent = domainNames.joined(separator: "\n")
            
            try context.createOutputFile(at: "CNAME").write(fileContent)
        }
    }
    
    /// Returns a plugin that copies a custom domain name file from the website's resources directory to the website's
    /// output directory.
    ///
    /// - Throws: `CNAME_Error.listEmpty` if the provided list from the file is empty.
    static func addCNAME() -> Self {
        Plugin(name: "Generate CNAME from existing CNAME file in the Resources directory") { context in
            let file = try context.file(at: "Resources/CNAME")
            
            let fileContent = try file.readAsString()
            
            guard !fileContent.isEmpty else { throw CNAMEGenerationError.listEmpty }
            
            try context.copyFileToOutput(from: "Resources/CNAME")
        }
    }
}
