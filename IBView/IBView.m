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

@property (strong, nonatomic) id privateNibView;
@property (assign, nonatomic, getter=isReadyForNib) BOOL readyForNib;
@property (strong, nonatomic) NSString *nibNameForInterfaceBuilder;

@end

@implementation IBView

@synthesize nibName = _nibName;

- (NSString *)nibName
{
    if (! _nibName) {
        _nibName = [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
    }
    return _nibName;
}

- (void)setNibName:(NSString *)nibName
{
    if (nibName != _nibName) {
        _nibName = [nibName copy];
        if (self.isReadyForNib) {
            [self nibNameDidChange];
        }
    }
}

#if TARGET_OS_IPHONE

- (UIView *)nibView
{
    return self.privateNibView;
}

#else

- (NSView *)nibView
{
    return self.privateNibView;
}

#endif

- (void)nibViewDidChange
{
}

#if ! TARGET_INTERFACE_BUILDER

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.readyForNib = YES;
    }
    return self;
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
    if (! [self.nibName isEqualToString:@"IBView"]) {
        [self.privateNibView removeFromSuperview];
        self.privateNibView = [self nibViewWithNibName:self.nibName];
        if (self.privateNibView) {
            [self addNibView:self.privateNibView];
            [self nibViewDidChange];
        }
    }
}

- (id)nibViewWithNibName:(NSString *)nibName
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
            nib = [UINib nibWithNibName:nibName bundle:bundle];
            if (nib) {
#if TARGET_INTERFACE_BUILDER
                @try {
                    objects = [nib instantiateWithOwner:self options:nil];
                }
                @catch (NSException *exception) {
                }
#else
                objects = [nib instantiateWithOwner:self options:nil];
#endif
                if (objects.count) {
                    nibs[nibName] = nib;
                }
            }
        }

        for (id object in objects) {
            if ([object isKindOfClass:[UIView class]]) {
                return object;
            }
        }

#else

        if (nib) {
            [nib instantiateWithOwner:self topLevelObjects:&objects];
        }
        else {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
            if (nib) {
#if TARGET_INTERFACE_BUILDER
                @try {
                    [nib instantiateWithOwner:self topLevelObjects:&objects];
                }
                @catch (NSException *exception) {
                }
#else
                [nib instantiateWithOwner:self topLevelObjects:&objects];
#endif
                if (objects.count) {
                    nibs[nibName] = nib;
                }
            }
        }

        for (id object in objects) {
            if ([object isKindOfClass:[NSView class]]) {
                return object;
            }
        }

#endif

    }

    return nil;
}

- (void)addNibView:(id)nibView
{
    [nibView setTranslatesAutoresizingMaskIntoConstraints:NO];
#if TARGET_OS_IPHONE
    [self insertSubview:nibView atIndex:0];
#else
    [self addSubview:nibView positioned:NSWindowBelow relativeTo:nil];
#endif
    NSDictionary *views = NSDictionaryOfVariableBindings(nibView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nibView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nibView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

@end
