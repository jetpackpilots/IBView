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

@property (assign, nonatomic, getter=isReadyForNib) BOOL readyForNib;
@property (strong, nonatomic) NSString *nibNameForInterfaceBuilder;
@property (strong, nonatomic) id nibView;
@property (strong, nonatomic) NSArray *nibObjects;

@end

@implementation IBView

+ (NSString *)nibName
{
    return [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
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
    if (! [nibName isEqualToString:_nibName]) {
        _nibName = [nibName copy];
        if (self.isReadyForNib) {
            [self nibNameDidChange];
        }
    }
}

#if TARGET_OS_IPHONE

- (UIView *)embeddedView
{
    return self.nibView;
}

#else

- (NSView *)embeddedView
{
    return self.nibView;
}

#endif

- (instancetype)initWithNibName:(NSString *)nibName
{
#if TARGET_OS_IPHONE
    self = [super initWithFrame:CGRectZero];
#else
    self = [super initWithFrame:NSZeroRect];
#endif
    if (self) {
        self.readyForNib = YES;
        self.nibName = [nibName copy] ?: [self.class nibName];
    }
    return self;
}

#if ! TARGET_INTERFACE_BUILDER

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithNibName:nil];
}

#endif

- (void)prepareForInterfaceBuilder
{
    if (! [self.nibName isEqualToString:self.nibNameForInterfaceBuilder]) {
        self.nibNameForInterfaceBuilder = self.nibName;
        [self nibNameDidChange];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    if (! self.isReadyForNib) {
        self.readyForNib = YES;
        [self nibNameDidChange];
    }
}

- (void)nibNameDidChange
{
    [self.nibView removeFromSuperview];

    self.nibView = nil;

    if (! [self.nibName isEqualToString:@"IBView"]) {

        self.nibObjects = [self nibObjectsWithNibName:self.nibName];

#if TARGET_OS_IPHONE
        for (id object in self.nibObjects) {
            if ([object isKindOfClass:[UIView class]]) {
                self.nibView = object;
            }
        }
#else
        for (id object in self.nibObjects) {
            if ([object isKindOfClass:[NSView class]]) {
                self.nibView = object;
            }
        }
#endif

        if (self.nibView) {
            [self embedNibView:self.nibView];
        }

    }
}

- (NSArray *)nibObjectsWithNibName:(NSString *)nibName
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    nibName = [nibName stringByDeletingPathExtension];

    if (nibName.length) {

        NSArray *objects;
        id nib = nibs[nibName];

#if TARGET_OS_IPHONE

        if (nib) {
            objects = [nib instantiateWithOwner:self options:nil];
        }
        else {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            if ([bundle URLForResource:nibName withExtension:@"nib"]) {
                nib = [UINib nibWithNibName:nibName bundle:bundle];
                objects = [nib instantiateWithOwner:self options:nil];
                if (objects.count) {
                    nibs[nibName] = nib;
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
            if ([bundle URLForResource:nibName withExtension:@"nib"]) {
                nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
                [nib instantiateWithOwner:self topLevelObjects:&objects];
                if (objects.count) {
                    nibs[nibName] = nib;
                }
            }
        }

        return objects;

#endif

    }

    return nil;
}

- (void)embedNibView:(id)nibView
{
#if TARGET_OS_IPHONE
    UIView *view;
    if ([nibView isKindOfClass:[UIView class]]) {
        view = nibView;
    }
#else
    NSView *view;
    if ([nibView isKindOfClass:[NSView class]]) {
        view = nibView;
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
