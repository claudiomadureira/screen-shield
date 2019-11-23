# MSScreenShield

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 5.0 and iOS 11.0 or later.

## Installation

MSScreenShield is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MSScreenShield'
```

## Usage

```swift
// Adding shield to some view.
view.addShield(withColor: .black)

// Removing shield.
view.removeShield()

// Instantiating a listener.
let listener = MSScreenshotListener(handler: { [weak self] in
    // Do something after user taking screenshot.
})

// Binding listener.
MSScreenShield.bind(listener)

// Removing listener.
MSScreenShield.unbind(listener)
```

## Author

Cláudio Madureira, claudiomsilvaf@gmail.com

## License

MSScreenShield is available under the MIT license. See the LICENSE file for more info.
