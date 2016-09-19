# StarryStars

StarryStars is iOS GUI library for displaying and editing ratings

## Features
StarryStars' ```RatingView``` is both ```IBDesignable``` and ```IBInspectable```

You can change any of the following properties right in the interface builder:

![Properties](http://i.imgur.com/puU9Ypc.png)

And see the result right away:

![RatingView](http://i.imgur.com/r3bMqDT.png)

To add RatingView to your Storyboard/.xib file just drag a generic UIView from palette, then in "Custom Class" section of identity inspector set class to ```RatingView```

## Installation

### Manual
Just clone and add ```StarryStars``` directory to your project.

### Cocoapods
- Make sure that you use latest stable Cocoapods version: `pod --version`
- If not, update it: `sudo gem install cocoapods`
- `pod init` in you project root dir
- `nano Podfile`, add:

```
pod 'StarryStars', '~> 0.0.1'
use_frameworks! 
``` 
- Save it: `ctrl-x`, `y`, `enter`
- `pod update`
- Open generated `.xcworkspace`
- Don't forget to import StarryStars: `import StarryStars`!

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0 (for older versions, see `swift-2.2` branch)

## Other Projects

[SwiftOverlays](https://github.com/peterprokop/SwiftOverlays) - Swift GUI library for displaying various popups and notifications.
