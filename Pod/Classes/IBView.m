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

#import "IBViewAdditions.h"

@interface IBView ()

@property (strong, nonatomic) id nibView;
@property (strong, nonatomic) NSString *nibNameForInterfaceBuilder;
@property (assign, nonatomic) BOOL awokeFromNib;

@end

@implementation IBView

@synthesize nibName = _nibName;

- (NSString *)nibName
{
    if (! _nibName) {
        _nibName = [self IBView_defaultNibName];
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
    if (! self.awokeFromNib) {
        self.awokeFromNib = YES;
        [self nibNameDidChange];
    }
}

- (void)nibNameDidChange
{
    if (! [self.nibName isEqualToString:@"IBView"]) {
        [self.nibView removeFromSuperview];
        self.nibView = [self IBView_nibViewWithNibName:self.nibName];
        if (self.nibView) {
            [self IBView_addNibView:self.nibView toView:self];
        }
    }
}

@end
