//
//  AlertService.swift
//  TMDB
//
//  Created by Pavlo on 13.02.2024.
//

import Foundation
import ProgressHUD
import UIKit

final class AlertService {
    
    static var shared = AlertService()
    
    private init() {}
    
    private func getErrorMessage(_ error: Error) -> String {
        if let error = error as? RESTError {
            return error.errorDescription
        } else if let error = error as? StorageError {
            return error.errorDescription
        } else {
            return error.localizedDescription
        }
    }
    
    func showError(_ error: Error, delay: TimeInterval = 3.5) {
        let message = getErrorMessage(error)
        ProgressHUD.banner("Error", message, delay: delay)
    }
    
    func showIcon(_ liveIcon: LiveIcon) {
        ProgressHUD.liveIcon(icon: liveIcon)
    }
}
