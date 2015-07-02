<p align="center">
  <img src="https://raw.githubusercontent.com/jetpackpilots/IBView/assets/IBView.png" alt="IBView" title="IBView">
</p>

A no-nonsense view subclass to use nibs inside other nibs and storyboards,
with Interface Builder live-previews. Supports UIView, NSView, IBDesignable,
IBInspectable, multiple-nesting and further subclassing.

## Purpose

Storyboards and nibs are great. But they tend to be used in a very view controller centric way.  Custom view subclasess where the UI of the view exists in it's own nib have always been possible.
The problem is that Xcode does not provide a standard implementation and you must rely on your
own code to load the nibs. That's where IBView comes in. When subclassing IBView you can now
design your view's user interface in a separate nib just for the view itself. IBView takes care
of the plumbing to make it work. And thanks to the new IBDesignable feature of Xcode, when you
place your custom view into a storyboard (or other nib), you see a live preview the contents of
your custom view's interface.

## Possible Uses

- Design a view's user interface in it's own nib file.
- Change a view's user interface at runtime simply by changing it's nib name.
- A/B test two different UI designs for a view.
- Set a view's nib based on the device or other runtime attributes.
- Re-use a custom view throughout the app for a consistent user experience.
- Share a user interface implementation between a view and a table/collection view.
- To avoid excessive view logic in controllers, pair each view controller with an IBView subclass with it's own nib.

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
