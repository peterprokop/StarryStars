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

### Carthage
- `cd` to your project folder
- `touch Cartfile` (if you don't have one yet)
- `nano Cartfile`
- put `github "peterprokop/StarryStars" == 2.0.0` into Cartfile
- Save it: `ctrl-x, y, enter`
- Run `carthage update`
- Copy framework from `Carthage/Build/iOS` to your project
- Make sure that framework is added in Embedded Binaries section of your target (or else you will get dyld library not loaded referenced from ... reason image not found error)
- Add  `import StarryStars` on top of your view controller's code

### Manual
Just clone and add ```StarryStars``` directory to your project.

### Cocoapods
- Make sure that you use latest stable Cocoapods version: `pod --version`
- If not, update it: `sudo gem install cocoapods`
- `pod init` in you project root dir
- `nano Podfile`, add:

```
pod 'StarryStars', '~> 2.0.0'
use_frameworks! 
``` 
- Save it: `ctrl-x`, `y`, `enter`
- `pod update`
- Open generated `.xcworkspace`
- Don't forget to import StarryStars: `import StarryStars`!

## Requirements

- iOS 10.0+
- Xcode 10.0+
- Swift 5.0 (for older versions, see `swift-2.2` branch)

## Usage from code

Swift:
```
let rvRightToLeft = RatingView()

rvRightToLeft.frame = view.bounds

view.addSubview(rvRightToLeft)
rvRightToLeft.editable = true
rvRightToLeft.delegate = self

// RatingView will respect setting this property
rvRightToLeft.semanticContentAttribute = .forceRightToLeft
```

Objective C:
```
RatingView* rvRightToLeft = [[RatingView alloc] init];

rvRightToLeft.frame = self.view.bounds;

[self.view addSubview:rvRightToLeft];
rvRightToLeft.editable = YES;
rvRightToLeft.delegate = self;

// RatingView will respect setting this property
rvRightToLeft.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
```

## Other Projects

[SwiftOverlays](https://github.com/peterprokop/SwiftOverlays) - Swift GUI library for displaying various popups and notifications.
