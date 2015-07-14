//
//  IBView.m
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

#import "IBView.h"

@interface IBView ()

#if TARGET_OS_IPHONE
@property (strong, nonatomic) UIView *contentView;
#else
@property (strong, nonatomic) NSView *contentView;
#endif

@property (readonly) NSArray *nibObjects;

@end

@implementation IBView

+ (NSString *)nibName
{
    NSString *nibName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;

    return [nibName isEqualToString:@"IBView"] ? nil : nibName;
}

@synthesize nibName = _nibName;

- (NSString *)nibName
{
    if (! _nibName) {
        _nibName = [self.class nibName];
    }

    return _nibName;
}

- (void)setNibName:(NSString *)nibName
{
    nibName = [nibName stringByDeletingPathExtension];

    if (! [nibName isEqualToString:_nibName]) {

        _nibName = [nibName copy];

        if (self.contentView) {
            [self.contentView removeFromSuperview];
            self.contentView = nil;
        }

        if (_nibName.length) {
#if TARGET_OS_IPHONE
            [self setNeedsLayout];
#else
            self.needsLayout = YES;
#endif
        }

    }
}

- (NSArray *)nibObjects
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    if (self.nibName.length) {

        NSArray *objects;
        id nib = nibs[self.nibName];

#if TARGET_OS_IPHONE

        if (nib) {
            objects = [nib instantiateWithOwner:self options:nil];
        }
        else {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            if ([bundle URLForResource:self.nibName withExtension:@"nib"]) {
                nib = [UINib nibWithNibName:self.nibName bundle:bundle];
                objects = [nib instantiateWithOwner:self options:nil];
                if (objects.count) {
                    nibs[self.nibName] = nib;
                }
            }
        }

        return objects;

#else

        if (nib) {
            [nib instantiateWithOwner:self topLevelObjects:&objects];
        }
        else {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            if ([bundle URLForResource:self.nibName withExtension:@"nib"]) {
                nib = [[NSNib alloc] initWithNibNamed:self.nibName bundle:bundle];
                [nib instantiateWithOwner:self topLevelObjects:&objects];
                if (objects.count) {
                    nibs[self.nibName] = nib;
                }
            }
        }

        return objects;

#endif

    }

    return nil;
}

- (instancetype)initWithNibName:(NSString *)nibName
{
#if TARGET_OS_IPHONE
    self = [super initWithFrame:CGRectZero];
#else
    self = [super initWithFrame:NSZeroRect];
#endif
    if (self) {
        self.nibName = [nibName copy] ?: [self.class nibName];
    }
    return self;
}

#if TARGET_OS_IPHONE

- (void)layoutSubviews
{
    if (! self.contentView) {
        for (id object in [self nibObjects]) {
            if ([object isKindOfClass:[UIView class]]) {
                self.contentView = object;
                break;
            }
        }
        if (self.contentView) {
            [self addContentView];
        }
    }

    [super layoutSubviews];
}

#else

- (void)layout
{
    if (! self.contentView) {
        for (id object in [self nibObjects]) {
            if ([object isKindOfClass:[NSView class]]) {
                self.contentView = object;
                break;
            }
        }
        if (self.contentView) {
            [self addContentView];
            [self.contentView layoutSubtreeIfNeeded];
        }
    }

    [super layout];
}

#endif

- (void)addContentView
{
#if TARGET_OS_IPHONE
    UIView *view;
    if ([self.contentView isKindOfClass:[UIView class]]) {
        view = self.contentView;
    }
#else
    NSView *view;
    if ([self.contentView isKindOfClass:[NSView class]]) {
        view = self.contentView;
    }
#endif

    if (view) {

#if TARGET_OS_IPHONE
        if (CGRectEqualToRect(self.frame, CGRectZero)) {
            self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        }
#else
        if (NSEqualRects(self.frame, NSZeroRect)) {
            self.frame = NSMakeRect(0.0, 0.0, NSWidth(view.frame), NSHeight(view.frame));
        }
#endif

        [view setTranslatesAutoresizingMaskIntoConstraints:NO];

#if TARGET_OS_IPHONE
        [self insertSubview:view atIndex:0];
#else
        [self addSubview:view positioned:NSWindowBelow relativeTo:nil];
#endif

        NSDictionary *views = NSDictionaryOfVariableBindings(view);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];

    }
}

@end
