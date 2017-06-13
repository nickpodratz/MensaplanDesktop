//
//  File.swift
//  HPI-Mobile
//
//  Created by Nick Podratz on 16.12.16.
//  Copyright © 2016 HPI Mobile Developer Klub. All rights reserved.
//

import Foundation

enum FileError: Error {
    
    case notFound(file: File)
    case unableToRead(file: File)
    case other(error: Error, withFile: File)
    
    var jsonFormatted: String {
        switch self {
        case .notFound(let file):
            return "\"error\": \"Can't find '\(file.nameWithSuffix)' file.\""
        case .unableToRead(let file):
            return "\"error\": \"Can't read '\(file.nameWithSuffix)' file.\""
        case let .other(error, file):
            return "\"error\": \"An error occured while processing '\(file.nameWithSuffix)': \(error.localizedDescription)\""
        }
    }
    
    var jsonFormattedData: Data? {
        return jsonFormatted.data(using: .utf8)
    }
    
    
}


struct File {
    
    var name: String
    var suffix: String
    var bundle: Bundle
    
    init(name: String, suffix: String, bundle: Bundle = Bundle.main) {
        self.name = name
        self.suffix = suffix
        self.bundle = bundle
    }
    
    var nameWithSuffix: String {
        return name + "." + suffix
    }
    
    var absolutePath: String? {
        return bundle.path(forResource: name, ofType: suffix)
    }
    
    func readContents(withOptions options: NSData.ReadingOptions = .mappedIfSafe ) throws -> Data {
        guard let absolutePath = self.absolutePath else {
            throw FileError.notFound(file: self)
        }
        let data = try NSData(contentsOfFile: absolutePath, options: options)
        return data as Data
    }
    
    
}

