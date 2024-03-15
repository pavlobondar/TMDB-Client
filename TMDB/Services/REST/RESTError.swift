//
//  RESTError.swift
//  TMDB
//
//  Created by Pavlo on 13.02.2024.
//

import Foundation

enum RESTError: Error {
    case noInternetConnection
    case invalidService
    case authenticationFailed
    case invalidFormat
    case invalidParameters
    case invalidID
    case invalidAPIKey
    case duplicateEntry
    case serviceOffline
    case suspendedAPIKey
    case internalError
    case itemUpdated
    case itemDeleted
    case failed
    case deviceDenied
    case sessionDenied
    case validationFailed
    case invalidAcceptHeader
    case invalidDateRange
    case entryNotFound
    case invalidPage
    case invalidDate
    case requestTimeout
    case requestCountExceeded
    case missingCredentials
    case tooManyAppendToResponseObjects
    case invalidTimezone
    case actionConfirmationRequired
    case invalidCredentials
    case accountDisabled
    case emailNotVerified
    case invalidRequestToken
    case resourceNotFound
    case invalidToken
    case writePermissionDenied
    case sessionNotFound
    case permissionDenied
    case resourcePrivate
    case nothingToUpdate
    case requestTokenNotApproved
    case unsupportedRequestMethod
    case backendConnectionError
    case invalidIDError
    case userSuspended
    case apiMaintenance
    case invalidInput
    
    init?(statusCode: Int) {
        switch statusCode {
        case 501:
            self = .invalidService
        case 401:
            self = .authenticationFailed
        case 405:
            self = .invalidFormat
        case 422:
            self = .invalidParameters
        case 403:
            self = .duplicateEntry
        case 503:
            self = .serviceOffline
        case 500:
            self = .internalError
        case 201:
            self = .itemUpdated
        case 400:
            self = .validationFailed
        case 406:
            self = .invalidAcceptHeader
        case 504:
            self = .requestTimeout
        case 429:
            self = .requestCountExceeded
        case 404:
            self = .resourceNotFound
        case 502:
            self = .backendConnectionError
        default:
            return nil
        }
    }

    var errorDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection"
        case .invalidService:
            return "Invalid service: this service does not exist."
        case .authenticationFailed:
            return "Authentication failed: You do not have permissions to access the service."
        case .invalidFormat:
            return "Invalid format: This service doesn't exist in that format."
        case .invalidParameters:
            return "Invalid parameters: Your request parameters are incorrect."
        case .invalidID:
            return "Invalid id: The pre-requisite id is invalid or not found."
        case .invalidAPIKey:
            return "Invalid API key: You must be granted a valid key."
        case .duplicateEntry:
            return "Duplicate entry: The data you tried to submit already exists."
        case .serviceOffline:
            return "Service offline: This service is temporarily offline, try again later."
        case .suspendedAPIKey:
            return "Suspended API key: Access to your account has been suspended, contact TMDB."
        case .internalError:
            return "Internal error: Something went wrong, contact TMDB."
        case .itemUpdated:
            return "The item/record was updated successfully."
        case .itemDeleted:
            return "The item/record was deleted successfully."
        case .failed:
            return "Failed."
        case .deviceDenied:
            return "Device denied."
        case .sessionDenied:
            return "Session denied."
        case .validationFailed:
            return "Validation failed."
        case .invalidAcceptHeader:
            return "Invalid accept header."
        case .invalidDateRange:
            return "Invalid date range: Should be a range no longer than 14 days."
        case .entryNotFound:
            return "Entry not found: The item you are trying to edit cannot be found."
        case .invalidPage:
            return "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer."
        case .invalidDate:
            return "Invalid date: Format needs to be YYYY-MM-DD."
        case .requestTimeout:
            return "Your request to the backend server timed out. Try again."
        case .requestCountExceeded:
            return "Your request count is over the allowed limit of (40)."
        case .missingCredentials:
            return "You must provide a username and password."
        case .tooManyAppendToResponseObjects:
            return "Too many append to response objects: The maximum number of remote calls is 20."
        case .invalidTimezone:
            return "Invalid timezone: Please consult the documentation for a valid timezone."
        case .actionConfirmationRequired:
            return "You must confirm this action: Please provide a confirm=true parameter."
        case .invalidCredentials:
            return "Invalid username and/or password: You did not provide a valid login."
        case .accountDisabled:
            return "Account disabled: Your account is no longer active. Contact TMDB if this is an error."
        case .emailNotVerified:
            return "Email not verified: Your email address has not been verified."
        case .invalidRequestToken:
            return "Invalid request token: The request token is either expired or invalid."
        case .resourceNotFound:
            return "The resource you requested could not be found."
        case .invalidToken:
            return "Invalid token."
        case .writePermissionDenied:
            return "This token hasn't been granted write permission by the user."
        case .sessionNotFound:
            return "The requested session could not be found."
        case .permissionDenied:
            return "You don't have permission to edit this resource."
        case .resourcePrivate:
            return "This resource is private."
        case .nothingToUpdate:
            return "Nothing to update."
        case .requestTokenNotApproved:
            return "This request token hasn't been approved by the user."
        case .unsupportedRequestMethod:
            return "This request method is not supported for this resource."
        case .backendConnectionError:
            return "Couldn't connect to the backend server."
        case .invalidIDError:
            return "The ID is invalid."
        case .userSuspended:
            return "This user has been suspended."
        case .apiMaintenance:
            return "The API is undergoing maintenance. Try again later."
        case .invalidInput:
            return "The input is not valid."
        }
    }
}
