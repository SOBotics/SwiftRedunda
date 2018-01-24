import Foundation

public class RedundaClient {
    public var key: String
    public var version: String?
    
    public init(key: String, version: String? = nil) {
        self.key = key
        self.version = version
    }
    
    public func ping(callback: @escaping (RedundaPingResponse?, Error?) -> ()) {
        self.ping(key: key, version: version) { res, err in
            callback(res, err)
        }
    }
    
    public func ping(key: String, version: String?, callback: @escaping (RedundaPingResponse?, Error?) -> ()) {
        let url = URL(string: "https://redunda.sobotics.org/status.json")!
        let params = version != nil ? ["key": key]: ["key": key, "version": version!]
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            callback(nil, RedundaError.invalidPingParams(params))
            return
        }
        req.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: req) { (data, res, err) in
            if let err = err {
                callback(nil, err)
                return
            }
            if let data = data {
                do {
                    let jsonRes = try JSONDecoder().decode(RedundaPingResponse.self, from: data)
                    callback(jsonRes, nil)
                    return
                } catch {
                    callback(nil, RedundaError.invalidPingJsonResponseData)
                    return
                }
            }
        }.resume()
    }
}

enum RedundaError: Error {
    case invalidPingParams([String: Any])
    case invalidPingJsonResponseData
}
