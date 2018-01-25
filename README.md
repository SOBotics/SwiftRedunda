# SwiftRedunda

[![Build Status](https://travis-ci.org/SOBotics/SwiftRedunda.svg?branch=master)](https://travis-ci.org/SOBotics/SwiftRedunda)

SwiftRedunda is a library to ping Redunda.

### Installation:

Using the Swift Package Manager:

In the `dependencies` section of your `Package.swift`, add the following package:

```swift
.package(url: "https://github.com/SOBotics/SwiftRedunda.git", from: "0.1.0")
```

Add `"SwiftRedunda"` to the `dependencies` array in the `.target` of `targets`.

Installation complete!

### Usage

On top of your swift file, import the module:

```swift
import SwiftRedunda
```

Then use `RedundaPingService` to ping the server.

```swift
let pingService = RedundaPingService(key: "YOUR_KEY_HERE", version: "1.0") // remember to generate a key at redunda.sobotics.org first!
pingService.startPinging()
```

Before posting chat messages, remember to see if you should be in standby mode first!

```swift
if !pingService.shouldStandby {
    // post messages
}
```

You should also use a class which conforms to the protocol `RedundaPingServiceDelegate` to receive errors. Set the delegate of you `RedundaPingService` using the following:

```swift
pingService.delegate = PingServiceDelegate
```

where `PingServiceDelegate` conforms to `RedundaPingServiceDelegate`.

You can set the service to debug mode with `pingService.debug = true`. If this value is true, Redunda won't be pinged.

### Report bugs

Report bugs in the [issues](https://github.com/SOBotics/SwiftRedunda/issues) section of this repository.

### Contact me

You can contact me by pinging me with @paper in chat in the [SOBotics](https://chat.stackoverflow.com/rooms/111347/sobotics) chat room.
