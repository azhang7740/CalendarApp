//
//  NetworkHandler.swift
//  CalendarApp
//
//  Created by Angelina Zhang on 7/25/22.
//

import Foundation
import Network

@objc
public protocol NetworkChangeDelegate {
    func didChangeOnline();
    func didChangeOffline();
}

@objcMembers
class NetworkHandler : NSObject {
    public weak var delegate : NetworkChangeDelegate?
    public var isOnline = false
    private let monitor = NWPathMonitor()
    private var status : NWPath.Status = .requiresConnection
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.delegate?.didChangeOnline()
                }
                self?.isOnline = true;
            } else {
                DispatchQueue.main.async {
                    self?.delegate?.didChangeOffline()
                }
                self?.isOnline = false
            }
        }
        let queue = DispatchQueue(label: "NetworkHandler")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
