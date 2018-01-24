import Foundation

public class RedundaPingService {
    public var key: String
    public var version: String?
    public var delegate: RedundaPingServiceDelegate?
    fileprivate let client: RedundaClient
    fileprivate var location = ""
    fileprivate var eventCount = 0
    fileprivate var standby = false {
        didSet {
            delegate?.statusChanged(newStatus: standby)
        }
    }
    
    public init(key: String, version: String? = nil) {
        self.key = key
        self.version = version
        self.client = RedundaClient(key: key, version: version)
    }
    
    public func startPinging(timeInterval: Double) {
        #if available
            var _ = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
                self.ping()
            }
        #endif
    }
    
    public func ping() {
        client.ping { res, err in
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
        return standby
    }
    
    public func getLocation() -> String {
        return location
    }
    
    public func getEventCount() -> Int {
        return eventCount
    }
}

public protocol RedundaPingServiceDelegate {
    func handle(error: Error)
    func statusChanged(newStatus: Bool)
    func pinged(response: RedundaPingResponse)
}
