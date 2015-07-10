<p align="center">
  <img src="https://raw.githubusercontent.com/jetpackpilots/IBView/assets/IBView.png" alt="IBView" title="IBView">
</p>

[![CI Status](http://img.shields.io/travis/jetpackpilots/IBView.svg?style=flat)](https://travis-ci.org/jetpackpilots/IBView)
[![Version](https://img.shields.io/cocoapods/v/IBView.svg?style=flat)](http://cocoapods.org/pods/IBView)
[![License](https://img.shields.io/cocoapods/l/IBView.svg?style=flat)](http://cocoapods.org/pods/IBView)
[![Platform](https://img.shields.io/cocoapods/p/IBView.svg?style=flat)](http://cocoapods.org/pods/IBView)

A no-nonsense view subclass to use nibs inside other nibs and storyboards,
with Interface Builder live-previews. Supports UIView, NSView, IBDesignable,
IBInspectable, multiple-nesting and further subclassing.

## Purpose

Storyboards and nibs are great. But they tend to be used in a very view controller centric way.
Custom view subclasess where the UI of the view exists in it's own nib have always been possible.
The problem is that Xcode does not provide a standard implementation and you must rely on your
own code to load the nibs. That's where IBView comes in. When subclassing IBView you can now
design your view's user interface in a separate nib just for the view itself, while IBView takes
care of the plumbing to make it work. And thanks to the new IBDesignable feature of Xcode, when
you place your custom view into a storyboard (or other nib), you will see a live preview of the
contents of your custom view's interface.

## Possible Uses

- Design a view's user interface in it's own nib file.
- Change a view's user interface at runtime simply by changing it's nib name.
- A/B test two different UI designs for a view.
- Set a view's nib based on the device or other runtime attributes.
- Use a custom view throughout an app's UI for a consistent user experience.
- Share an interface implementation between a view and a table/collection view.
- To avoid excessive view logic in controllers, pair each view controller with an IBView subclass with it's own nib.

## Requirements

##### When installed via CocoaPods:
- UIView: iOS 8.0+ / NSView: Mac OS X 10.9+

##### When installed manually:
- UIView: iOS 7.0+ / NSView: Mac OS X 10.8+

## Installation

IBView can be used in iOS or Mac projects. Installation is either done via [CocoaPods](http://cocoapods.org) **OR** manually.

#### CocoaPods Installation

Add `IBView` to your Podfile and be sure to use frameworks:

```ruby
use_frameworks!

pod "IBView"
```

Then install the pod using the [CocoaPods CLI](https://guides.cocoapods.org).

**NOTE:** When IBView is installed via **CocoaPods** and for **Mac** apps only, `'@loader_path/../Frameworks'` (including the quotes) needs to be added as an additional path to the `Runpath Search Paths` build setting.

#### Manual Installation

Manually add the [IBView class](https://github.com/jetpackpilots/IBView/tree/master/Pod/Classes) into your project.

**NOTE:** When IBView is installed **manually**, use `#import "IBView.h"` in place of `#import <IBView/IBView.h>` anywhere that appears in this README.

## Subclassing Notes

Subclassing IBView is supported in both **Objective-C** and **Swift**.

In either case, all subclasses need to explicitly declare themselves as IBDesignable.

#### Objective-C Example

```
#import <IBView/IBView.h>

IB_DESIGNABLE

@interface CustomView : IBView
@end

@implementation CustomView
@end
```

#### Swift Example

```Swift
import IBView

@IBDesignable class CustomView: IBView {
}
```

For Swift, you must import `IBView` in the [bridging header](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html):

```
#import <IBView/IBView.h>
```

## Quick Start

Using IBView is straightforward and always follows these basic steps:

1. Create a custom view by first adding a new `IBView` subclass to the project.
2. Declare the custom view as IBDesignable by adding `IB_DESIGNABLE` (Objective-C) or `@IBDesignable` (Swift) to the source code of the subclass.
3. Next add a nib for the custom view to the project. Be sure to select the `View` nib template in the *User Interface* section of the add file wizard. The name of the nib should **exactly match** the name of the class (except for the file extension of course).
4. In the nib, set the class of the `File's Owner` placeholder to the name of your custom class. This will allow you to make `IBOutlet` and `IBAction` connections from the nib to your custom class. Feel free to make those connections now, or at a later time.
5. Utilize the new IBView subclass in another nib or storyboard. To do this, simply add a view to another nib or storyboard and set it's class to your custom class.

That's it, you're done! In this other nib or storyboard, you should see a preview of the custom view's nib contents.

## Advanced Usage

IBView supports multiple nib files for a custom view. In other words, you may create several nib
files for a particular IBView subclass and then switch between them at runtime by simply changing
the `nibName` property. The naming convention for the nibs is entirely up to you.

Also, the `nibName` can be specified in Interface Builder via an IBInspectable property that shows
up in the *Attributes Inspector*. When left blank or unassigned, `IBView` defaults the `nibName`
property to the name of the class itself, so it is completely fine to leave it blank or unassigned
to use the default name. But you can set it to the name of another nib when you have a specific
use for that. For example, when there is no reason to have a nib with the same name as the class.

## A Note About Delegation

When utilizing IBView it quickly becomes clear that you are no longer able to make `IBOutlet`
and `IBAction` connections from objects inside your custom views' nibs to your view controllers.
This is by design and is the expected behavior of IBView.

One suggested approach to communicate events from custom views to view controllers is to use
delegation. By creating a delegate protocol for a custom view, you can encapsulate the view's
event handling within the view itself, and notify the view controller when events occur by calling
delegate methods.

To implement this type of delegation, the custom view will require a delegate protocol as well
as a delegate property that must conform to that protocol. The view controller can be set as the
custom view's delegate and will then implement the protocol methods. Note that the view controller
can be set as the view's delegate in code or with a connection in Interface Builder.

See [Working with Protocols](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithProtocols/WorkingwithProtocols.html) for more information.

## Class Compatibility

*Please feel free to [submit an issue](https://github.com/jetpackpilots/IBView/issues/new) to discuss class compatibility and/or incompatibility.*

#### iOS

Class                | Notes
-----                | -----
UIViewController     | It's view can be an IBView subclass.
UICollectionViewCell | An IBView subclass can be added as a subview of the cell's content view.
UITableViewCell      | An IBView subclass can be added as a subview of the cell's content view.

#### Mac

Class            | Notes
-----            | -----
NSViewController | It's view can actaully be an IBView subclass, but unfortunately live-previews do **NOT** work. So instead, add an IBView subclass as a subview of the NSViewController's view.

## Programmatic Instantiation

Although not the typical use for IBView, it is also possible to initialize your IBView subclasses
in code by using the designated initializer `initWithNibName:`. If you pass `nil`, the `nibName`
property will default to the name of the class.

## Troubleshooting

Select `Refresh All Views` from the `Editor` menu in Xcode whenever the live-previews get out
of sync. Sometimes you might need to resort to closing the Xcode project, deleting derived data,
quitting Xcode and then restarting the Mac.

## Known Issues

When IBView is installed via **CocoaPods**, the following known issues exist:

- The IBView base class cannot be used as a view class directly in Interface Builder, instead IBView subclasses should always be used.
- All IBView subclasses need to explicitly declare themselves as IBDesignable even though the base IBView class already does.
- For **Mac** apps, `'@loader_path/../Frameworks'` (including the quotes) needs to be added as an additional path to the `Runpath Search Paths` build setting.

*Those issues do not exist when IBView is installed manually.*

## Projects Using IBView

If you use IBView in your project, please consider adding a link to your app [to this thread](https://github.com/jetpackpilots/IBView/issues/1).

## Author

[Christopher Fuller](http://github.com/chrisfuller)

## Acknowledgments

- [Garo Hussenjian](http://github.com/garohussenjian) provided invaluable help in creating IBView, thank you.
- Thanks to [Steven Lin](http://stevenlin.net) for assistance with the IBView logo.

## License

IBView is available under the MIT license. See the LICENSE file for more info.
