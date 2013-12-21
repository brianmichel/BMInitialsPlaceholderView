//
//  BMInitialsPlaceholderView.m
//  
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Brian Michel <brian.michel@gmail.com>
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

#import "BMInitialsPlaceholderView.h"

@interface BMInitialsPlaceholderView ()
@property (strong) UIImage *cachedVisualRepresentation;
@end

@implementation BMInitialsPlaceholderView

@synthesize initials = _initials;
@synthesize textColor = _textColor;
@synthesize circleColor = _circleColor;
@synthesize font = _font;

- (instancetype)initWithDiameter:(CGFloat)diameter {
    self = [super initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.circleColor = [UIColor lightGrayColor];
        self.font = [UIFont boldSystemFontOfSize:16.0];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.cachedVisualRepresentation) {
        [self.cachedVisualRepresentation drawAtPoint:CGPointZero];
    }
}

#pragma mark - Setters / Getters
- (void)setInitials:(NSString *)initialialsToDraw {
    if ([initialialsToDraw length] > 2) {
        initialialsToDraw = [initialialsToDraw substringToIndex:2];
    }
    _initials = initialialsToDraw;
    [self generateCachedVisualRepresentation];
}

- (NSString *)initials {
    return _initials;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self generateCachedVisualRepresentation];
}

- (UIColor *)textColor {
    return _textColor ? _textColor : [UIColor whiteColor];
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self generateCachedVisualRepresentation];
}

- (UIColor *)circleColor {
    return _circleColor ? _circleColor : [UIColor lightGrayColor];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self generateCachedVisualRepresentation];
}

- (UIFont *)font {
    return _font ? _font : [UIFont boldSystemFontOfSize:16.0];
}

- (void)generateCachedVisualRepresentation {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        return;
    }
    _cachedVisualRepresentation = nil;
    
    NSString *fontNameToUse = self.font.fontName;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    //Create background circle and add it as a clipping mask.
    UIBezierPath *circleClip = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [circleClip addClip];
    UIRectClip(self.bounds);
    
    [self.circleColor setFill];
    UIRectFill(self.bounds);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    //Pythagoras!
    //Find the height/width of the largest enscribed square
    CGFloat inscribedSquareHeightWidth = sqrt(pow(self.bounds.size.width, 2.0)/2);
    
    //Set default font size so we can work out way down to the right size
    CGFloat fontSize = self.frame.size.height;
    CGSize boundingSize = CGSizeZero;
    while (fontSize != 0.0) {
        boundingSize =  [self.initials boundingRectWithSize:CGSizeMake(inscribedSquareHeightWidth, inscribedSquareHeightWidth) options:0 attributes:@{NSFontAttributeName : [UIFont fontWithName:fontNameToUse size:fontSize]} context:nil].size;
        
        //if the bounding size of our text with the given font is inside the enscribed rectangle, return, we have our info.
        if (boundingSize.height <= inscribedSquareHeightWidth && boundingSize.width <= inscribedSquareHeightWidth) break;
        
        fontSize -= 1.0;
    }
    
    //setup sizing information for rectangle and centering text
    CGFloat squareOrigin = (self.bounds.size.width/2) - (inscribedSquareHeightWidth/2);
    CGRect enscribedSquare  = CGRectMake(squareOrigin, squareOrigin, inscribedSquareHeightWidth, inscribedSquareHeightWidth);
    
    CGPoint drawingPoint = CGPointMake(enscribedSquare.origin.x + (enscribedSquare.size.width/2 - boundingSize.width/2), enscribedSquare.origin.y + (enscribedSquare.size.height/2 - boundingSize.height/2));
    [self.initials drawAtPoint:drawingPoint withAttributes:@{NSFontAttributeName : [UIFont fontWithName:fontNameToUse size:fontSize],
                                                             NSForegroundColorAttributeName : self.textColor,
                                                             NSParagraphStyleAttributeName : style}];
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    _cachedVisualRepresentation = outImage;
    [self setNeedsDisplay];
}


@end
