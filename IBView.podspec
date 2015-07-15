#
# Be sure to run `pod lib lint IBView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IBView"
  s.version          = "0.1.0"
  s.summary          = "A no-nonsense view subclass to use nibs inside other nibs and storyboards, with Interface Builder live-previews. Supports UIView & NSView."
  s.description      = <<-DESC
                       A no-nonsense view subclass to use nibs inside other nibs and storyboards,
                       with Interface Builder live-previews. Supports UIView, NSView, IBDesignable,
                       IBInspectable, multiple-nesting and further subclassing.
                       DESC
  s.homepage         = "https://github.com/jetpackpilots/IBView"
  s.license          = 'MIT'
  s.author           = { "Christopher Fuller" => "git@chrisfuller.me" }
  s.source           = { :git => "https://github.com/jetpackpilots/IBView.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.ios.source_files = 'Pod/Classes/UIView/**/*'
  s.ios.public_header_files = 'Pod/Classes/UIView/**/*.h'
  s.osx.source_files = 'Pod/Classes/NSView/**/*'
  s.osx.public_header_files = 'Pod/Classes/NSView/**/*.h'
  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'Cocoa'
end
