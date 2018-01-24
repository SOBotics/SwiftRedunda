public struct RedundaPingResponse: Decodable {
    var should_standby: Bool
    var location: String
    var event_count: Int
}
