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

@property (strong, nonatomic) NSString *previousNibName;

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

        _nibName = nibName;

        [self nibNameDidChange];

    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self nibNameDidChange];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self nibNameDidChange];
}

- (void)prepareForInterfaceBuilder
{
    [self nibNameDidChange];
}

- (void)nibNameDidChange
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    if ((! [self.nibName isEqualToString:@"IBView"]) && (! [self.nibName isEqualToString:self.previousNibName])) {

        self.previousNibName = self.nibName;

        for (id view in self.subviews) {
            [view removeFromSuperview];
        }

        if (self.nibName) {

#if TARGET_OS_IPHONE

            UINib *nib = nibs[self.nibName];

            if (! nib) {
                @try {
                    NSBundle *bundle = [NSBundle bundleForClass:self.class];
                    nib = [UINib nibWithNibName:self.nibName bundle:bundle];
                }
                @catch (NSException *exception) {
                }
                if (nib) {
                    nibs[self.nibName] = nib;
                }
            }

            if (nib) {
                NSArray *objects;
                @try {
                    objects = [nib instantiateWithOwner:self options:nil];
                }
                @catch (NSException *exception) {
                }
                for (id object in objects) {
                    if ([object isKindOfClass:[UIView class]]) {
                        [self addNibView:object];
                        break;
                    }
                }
            }

#else

            NSNib *nib = nibs[self.nibName];

            if (! nib) {
                @try {
                    NSBundle *bundle = [NSBundle bundleForClass:self.class];
                    nib = [[NSNib alloc] initWithNibNamed:self.nibName bundle:bundle];
                }
                @catch (NSException *exception) {
                }
                if (nib) {
                    nibs[self.nibName] = nib;
                }
            }

            if (nib) {
                NSArray *objects;
                @try {
                    [nib instantiateWithOwner:self topLevelObjects:&objects];
                }
                @catch (NSException *exception) {
                }
                for (id object in objects) {
                    if ([object isKindOfClass:[NSView class]]) {
                        [self addNibView:object];
                        break;
                    }
                }
            }

#endif

        }

    }
}

- (void)addNibView:(id)view
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:view];
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

@end
