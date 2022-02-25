//
//  PersistenceError.swift
//  PeggleClone
//
//  Created by Hong Yao on 29/1/22.
//

import Foundation

struct PersistenceError: Error {
    enum Operation: String {
        case fetch
        case save
        case delete
    }

    let className: String
    let failedOperation: Operation
    var reason: String?
}

extension PersistenceError: LocalizedError {
    public var errorDescription: String? {
        "Failed to \(failedOperation.rawValue) \(className)"
    }

    public var failureReason: String? {
        reason ?? "Something went wrong with the persistence store."
    }

    public var recoverySuggestion: String? {
        "Try again later."
    }
}
