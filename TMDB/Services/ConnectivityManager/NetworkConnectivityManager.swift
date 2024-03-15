//
//  NetworkConnectivityManager.swift
//  TMDB
//
//  Created by Pavlo on 06.03.2024.
//

import Foundation
import Network

final class NetworkConnectivityManager {
    
    static let shared = NetworkConnectivityManager()
    static let networkConnectivityDidChangeNotificationName = Notification.Name(rawValue: "_networkConnectivityDidChangeNotification")
    
    private let pathMonitor = NWPathMonitor()
    private let monitoringQueue = DispatchQueue(label: "com.com.bondar.TMDB.NetworkConnectivityManager", qos: .utility)
    
    var isOnline: Bool {
        return pathMonitor.currentPath.status == .satisfied
    }
    
    private init() {}
    
    func start() {
        pathMonitor.pathUpdateHandler = { path in
            NotificationCenter.default.post(name: Self.networkConnectivityDidChangeNotificationName, object: path.status)
        }
        pathMonitor.start(queue: monitoringQueue)
    }
    
    deinit {
        pathMonitor.cancel()
    }
}
