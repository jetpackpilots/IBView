//
//  IBViewAdditions.m
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

#import "IBViewAdditions.h"

#if TARGET_OS_IPHONE
@implementation UIView (IBViewAdditions)
#else
@implementation NSView (IBViewAdditions)
#endif

- (NSString *)IBView_defaultNibName
{
    return [NSStringFromClass([self class]) componentsSeparatedByString:@"."].lastObject;
}

- (id)IBView_nibViewWithNibName:(NSString *)nibName
{
    static NSMutableDictionary *nibs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nibs = [NSMutableDictionary dictionary];
    });

    if (nibName) {

        NSArray *objects;
        id nib = nibs[nibName];

        if (nib) {
            @try {
#if TARGET_OS_IPHONE
                objects = [nib instantiateWithOwner:self options:nil];
#else
                [nib instantiateWithOwner:self topLevelObjects:&objects];
#endif
            }
            @catch (NSException *exception) {
            }
        }
        else {
            for (NSBundle *bundle in [NSBundle allBundles]) {
                objects = nil;
#if TARGET_OS_IPHONE
                nib = [UINib nibWithNibName:nibName bundle:bundle];
#else
                nib = [[NSNib alloc] initWithNibNamed:nibName bundle:bundle];
#endif
                if (nib) {
                    @try {
#if TARGET_OS_IPHONE
                        objects = [nib instantiateWithOwner:self options:nil];
#else
                        [nib instantiateWithOwner:self topLevelObjects:&objects];
#endif
                    }
                    @catch (NSException *exception) {
                    }
                    if (objects) {
                        nibs[nibName] = nib;
                        break;
                    }
                    else {
                        nib = nil;
                    }
                }
            }
        }

        for (id object in objects) {
#if TARGET_OS_IPHONE
            if ([object isKindOfClass:[UIView class]]) {
                return object;
            }
#else
            if ([object isKindOfClass:[NSView class]]) {
                return object;
            }
#endif
        }

    }

    return nil;
}

- (void)IBView_addNibView:(id)nibView toView:(id)view
{
    [nibView setTranslatesAutoresizingMaskIntoConstraints:NO];
#if TARGET_OS_IPHONE
    [view insertSubview:nibView atIndex:0];
#else
    [view addSubview:nibView positioned:NSWindowBelow relativeTo:nil];
#endif
    NSDictionary *views = NSDictionaryOfVariableBindings(nibView);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nibView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nibView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

@end