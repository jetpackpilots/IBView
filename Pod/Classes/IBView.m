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

@end

@implementation IBView

+ (NSString *)defaultNibName
{
    NSString *nibName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;

    return [nibName isEqualToString:@"IBView"] ? nil : nibName;
}

+ (id)nibWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    id nib;

    if (nibName.length) {
        if (nibs[nibName]) {
            nib = nibs[nibName];
        }
        else {
            if ([bundle URLForResource:nibName withExtension:@"nib"]) {
#if TARGET_OS_IPHONE
                nib = [UINib nibWithNibName:nibName bundle:bundle];
#else
                nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
#endif
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
#if TARGET_OS_IPHONE
    self = [super initWithFrame:CGRectZero];
#else
    self = [super initWithFrame:NSZeroRect];
#endif

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
#if TARGET_OS_IPHONE
            [self setNeedsLayout];
#else
            self.needsLayout = YES;
#endif
        }

    }
}

#if TARGET_OS_IPHONE

#pragma mark Nib Property (UINib)

- (UINib *)nib
{
    if (! _nib) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _nib = [self.class nibWithNibName:self.nibName bundle:bundle];
    }

    return _nib;
}

#else

#pragma mark Nib Property (NSNib)

- (NSNib *)nib
{
    if (! _nib) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _nib = [self.class nibWithNibName:self.nibName bundle:bundle];
    }

    return _nib;
}

#endif

#if TARGET_OS_IPHONE

#pragma mark Content View Property (UIView)

- (UIView *)contentView
{
    return _contentView;
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView != _contentView) {
        _contentView = contentView;
        if (CGRectEqualToRect(self.frame, CGRectZero)) {
            self.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
        }
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self insertSubview:_contentView atIndex:0];
        [self addSuperviewEqualEdgesConstraintsToView:_contentView];
    }
}

#else

#pragma mark Content View Property (NSView)

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
        [self addSuperviewEqualEdgesConstraintsToView:_contentView];
    }
}

#endif

#pragma mark Layout Methods

#if TARGET_OS_IPHONE

- (void)layoutSubviews
{
    if (! self.contentView) {
        NSArray *objects = [self.nib instantiateWithOwner:self options:nil];
        for (id object in objects) {
            if ([object isKindOfClass:[UIView class]]) {
                self.contentView = object;
                break;
            }
        }
    }

    [super layoutSubviews];
}

#else

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

#endif

#pragma mark Constraints Methods

- (void)addSuperviewEqualEdgesConstraintsToView:(id)view
{
    BOOL isView = NO;
#if TARGET_OS_IPHONE
    isView = [view isKindOfClass:[UIView class]];
#else
    isView = [view isKindOfClass:[NSView class]];
#endif

    if (isView) {
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
