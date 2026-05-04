//
//  CoreDataError.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 04/05/2026.
//

import Foundation

enum CoreDataError: Error {
    
    case saveFailed
    case fetchFailed
    case deleteFailed
    case updateFailed
    case invalidData
    case entityNotFound
    case contextError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data to database"
        case .fetchFailed:
            return "Failed to fetch data from database"
        case .deleteFailed:
            return "Failed to delete data from database"
        case .updateFailed:
            return "Failed to update data"
        case .invalidData:
            return "Invalid data provided"
        case .entityNotFound:
            return "Entity not found in Core Data"
        case .contextError(let error):
            return "Context error: \(error.localizedDescription)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
