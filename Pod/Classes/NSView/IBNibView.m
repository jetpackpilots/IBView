//
//  IBNibView.m
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

#import "IBNibView.h"

@interface IBNibView ()

@property (strong, nonatomic) NSView *contentView;

@end

@implementation IBNibView

#pragma mark Class Methods

+ (NSString *)defaultNibName
{
    NSString *nibName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;

    return [nibName isEqualToString:@"IBNibView"] ? nil : nibName;
}

+ (NSNib *)nibWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    NSNib *nib;

    if (nibName.length) {
        if (nibs[nibName]) {
            nib = nibs[nibName];
        }
        else {
            if ([bundle URLForResource:nibName withExtension:@"nib"]) {
                nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
            }
            if (nib) {
                nibs[nibName] = nib;
            }
        }
    }

    return nib;
}

#pragma mark Designated Initializer

- (instancetype)initWithNibName:(NSString *)nibName
{
    self = [super initWithFrame:NSZeroRect];

    if (self) {
        self.nibName = [nibName copy] ?: [self.class defaultNibName];
    }

    return self;
}

#pragma mark Instance Variables

@synthesize nibName = _nibName;
@synthesize nib = _nib;
@synthesize contentView = _contentView;

#pragma mark Nib Name Property

- (NSString *)nibName
{
    if (! _nibName) {
        _nibName = [self.class defaultNibName];
    }

    return _nibName;
}

- (void)setNibName:(NSString *)nibName
{
    nibName = [nibName stringByDeletingPathExtension];

    if (! [nibName isEqualToString:_nibName]) {

        [_contentView removeFromSuperview];

        _nibName = [nibName copy];
        _nib = nil;
        _contentView = nil;

        if (_nibName.length) {
            self.needsLayout = YES;
        }

    }
}

#pragma mark Nib Property

- (NSNib *)nib
{
    if (! _nib) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _nib = [self.class nibWithNibName:self.nibName bundle:bundle];
    }

    return _nib;
}

#pragma mark Content View Property

- (NSView *)contentView
{
    return _contentView;
}

- (void)setContentView:(NSView *)contentView
{
    if (contentView != _contentView) {

        _contentView = contentView;

        if (NSEqualRects(self.frame, NSZeroRect)) {
            self.frame = NSMakeRect(0.0, 0.0, NSWidth(_contentView.frame), NSHeight(_contentView.frame));
        }

        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addSubview:_contentView positioned:NSWindowBelow relativeTo:nil];

        NSDictionary *views = NSDictionaryOfVariableBindings(_contentView);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

    }
}

#pragma mark NSView Methods

- (void)layout
{
    if (! self.contentView) {

        NSArray *objects;
        [self.nib instantiateWithOwner:self topLevelObjects:&objects];

        for (id object in objects) {
            if ([object isKindOfClass:[NSView class]]) {
                self.contentView = object;
                [self.contentView layoutSubtreeIfNeeded];
                break;
            }
        }

    }

    [super layout];
}

@end
