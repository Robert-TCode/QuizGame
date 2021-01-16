//  Created by TCode on 16/01/2021.

import Foundation
import Network

class NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    public var isOnlineConnectionAvailable: Bool = false

    public static var shared = NetworkReachability()

    private init() {
        startMonitoringConnection()
    }

    private func startMonitoringConnection() {
        monitor.pathUpdateHandler = { path in
            self.isOnlineConnectionAvailable = path.status == .satisfied
        }

        monitor.start(queue: queue)
    }
}
