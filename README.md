# IBView

A no-nonsense view subclass to use nibs inside other nibs and storyboards,
with Interface Builder live-previews. Supports UIView, NSView, IBDesignable,
IBInspectable, multiple-nesting and further subclassing.

## Requirements

- iOS 7.0+ / Mac OS X 10.8+
- Xcode 6.3

## Installation

Manually add the `IBView` and `IBViewAdditions` classes into your Mac or iOS project.

*NOTE: IBView is not currently available via [CocoaPods](http://cocoapods.org), see [known issues](#known-issues) for more information.*

## Known Issues

- IBView's IBDesignable functionality in Xcode's interface builder is intermittent when IBView
is distributed as a framework. Therefore manual installation is recommended for now, and IBView
distribution via [CocoaPods](http://cocoapods.org) is on hold until Xcode has improved IBDesignable
compatibility with framework views. If you are interested in checking it out or helping, IBView
has a [cocoapods branch](https://github.com/jetpackpilots/IBView/tree/cocoapods) for testing.

- **iOS Only:** To use IBView with UITableViewCell, add an IBView subclass as a subview of the cell's
content view.

- **Mac Only:** Live-previews do not work well for NSViewController views that are IBView subclasses.
Instead, add an IBView subclass as a subview of the NSViewController view.

## Author

[Christopher Fuller](http://github.com/chrisfuller)

## Acknowledgments

- [Garo Hussenjian](http://github.com/garohussenjian) provided invaluable help in creating IBView, thank you.

## License

IBView is available under the MIT license. See the LICENSE file for more info.
