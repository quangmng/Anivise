//
//  ConnectivityManager.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 10/10/2024.
//

import Foundation
import Network

class ConnectivityManager {
    static let shared = ConnectivityManager()

    private let monitor = NWPathMonitor()
    private var isMonitoring = false

    var isConnected: Bool = false
    var connectionType: NWInterface.InterfaceType?

    private init() {}

    func startMonitoring() {
        guard !isMonitoring else { return }

        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied

            if path.usesInterfaceType(.wifi) {
                self.connectionType = .wifi
            } else if path.usesInterfaceType(.cellular) {
                self.connectionType = .cellular
            } else {
                self.connectionType = nil
            }

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .connectivityChanged, object: nil)
            }
        }

        let queue = DispatchQueue(label: "ReachabilityMonitor")
        monitor.start(queue: queue)
        isMonitoring = true
    }

    func stopMonitoring() {
        guard isMonitoring else { return }
        monitor.cancel()
        isMonitoring = false
    }
}

extension Notification.Name {
    static let connectivityChanged = Notification.Name("connectivityChanged")
}
