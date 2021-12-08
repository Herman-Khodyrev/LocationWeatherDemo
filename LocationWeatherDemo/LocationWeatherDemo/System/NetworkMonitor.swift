//
//  NetworkMonitor.swift
//  LocationWeatherDemo1
//
//  Created by Герман on 27.11.21.
//

import Foundation
import Network

final class NetworkMonitor{

    static let shared = NetworkMonitor()

    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor

    public private(set) var isConnected: Bool = false

    private init(){
        monitor = NWPathMonitor()
    }

    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
        }

    }

    public func stopMonitiring(){
        monitor.cancel()
    }

}

//struct Connectivity {                                        // For Alamofire
//  static let sharedInstance = NetworkReachabilityManager()!
//  static var isConnectedToInternet:Bool {
//      return self.sharedInstance.isReachable
//    }
//}
