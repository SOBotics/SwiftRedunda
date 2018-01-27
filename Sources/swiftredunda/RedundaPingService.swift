import Foundation
#if os(Linux)
    import GLibc
#endif

public class RedundaPingService {
    public var key: String
    public var version: String?
    public var delegate: RedundaPingServiceDelegate?
    public var debug = false {
        didSet {
            if debug {
                self.stopPinging()
            } else if let _ = self.pingTimer {
                self.startPinging()
            }
        }
    }
    fileprivate let client: RedundaClient
    fileprivate var pingTimer: Timer?
    fileprivate var location = ""
    fileprivate var eventCount = 0
    fileprivate var standby = false {
        didSet {
            self.delegate?.statusChanged(newStatus: standby)
        }
    }
    
    public init(key: String, version: String? = nil) {
        self.key = key
        self.version = version
        self.client = RedundaClient(key: key, version: version)
    }
    
    public func startPinging(timeInterval: Double = 30.0) {
        if #available(OSX 10.12, *) {
            let t = Thread() {
                sleep(UInt32(timeInterval))
            }
            t.start()
        } else {
            fatalError("Pinging can't start because Thread is unavailable!")
        }
    }
    
    public func stopPinging() {
        self.pingTimer?.invalidate()
        self.pingTimer = nil
    }
    
    public func ping() {
        self.client.ping { res, err in
            if let err = err {
                self.delegate?.handle(error: err)
            }
            if let res = res {
                self.delegate?.pinged(response: res)
                self.standby = res.should_standby
                self.location = res.location
                self.eventCount = res.event_count
            }
        }
    }
    
    public func shouldStandby() -> Bool {
        return self.standby
    }
    
    public func getLocation() -> String {
        return self.location
    }
    
    public func getEventCount() -> Int {
        return self.eventCount
    }
}

public protocol RedundaPingServiceDelegate {
    func handle(error: Error)
    func statusChanged(newStatus: Bool)
    func pinged(response: RedundaPingResponse)
}
