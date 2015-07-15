//
//  IBDesignableView.m
//
//  Copyright (c) 2015 Jetpack Pilots, Inc. [http://jetpackpilots.com]
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "IBDesignableView.h"

@implementation IBDesignableView

#pragma mark Designated Initializer

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.wantsLayer = YES;
    }
    return self;
}

#pragma mark NSView Methods

- (BOOL)wantsUpdateLayer
{
    return YES;
}

- (void)updateLayer
{
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;

    if (self.cornerRadius != 0.0) {
        self.layer.masksToBounds = YES;
    }
}

#pragma mark Background Color Property

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;

    self.needsDisplay = YES;
}

- (NSColor *)background
{
    return self.backgroundColor;
}

- (void)setBackground:(NSColor *)background
{
    self.backgroundColor = background;
}

#pragma mark Border Color Property

- (void)setBorderColor:(NSColor *)borderColor
{
    _borderColor = borderColor;

    self.needsDisplay = YES;
}

#pragma mark Border Width Property

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;

    self.needsDisplay = YES;
}

#pragma mark Corner Radius Property

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;

    self.needsDisplay = YES;
}

@end
