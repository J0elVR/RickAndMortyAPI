//
//  NetworkMonitor.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 18/03/26.
//

import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let status = path.status == .satisfied
            self.isConnected = status
            
            DispatchQueue.main.async {
                self.onStatusChange?(status)
            }
        }
        
        monitor.start(queue: queue)
    }
}
