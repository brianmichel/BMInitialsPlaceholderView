//
//  BMInitialsPlaceholderView.h
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

#import <UIKit/UIKit.h>

/**
 A view that will facilitate the drawing of a placeholder
 image which contains the specified initials drawn over top
 of a circle. 
 
 This behavior can be seen in iMessage (iOS7 7.0+ and greater)
 when you are in a group chat.
 */
@interface BMInitialsPlaceholderView : UIView
/**
 Font to use for drawing
 
 @note The size doesn't matter as it is dynamically determined based on 
 the frame of this view. The default is [UIFont boldSystemFontOfSize:16]
 */
@property (strong) UIFont *font;

/**
 Color to use when drawing initial text.
 
 @note This defaults to [UIColor whiteColor]
 */
@property (strong) UIColor *textColor;

/**
 Color to use when drawing the background circle.
 
 @note THis defaults to [UIColor lightGrayColor]
 */
@property (strong) UIColor *circleColor;

/**
 String of initials to draw over top of the circle.
 
 @note If there are more than 2 character supplied in this string
 it will be truncated to 2 characters
 */
@property (strong) NSString *initials;

/**
 The designated initializer (using another initializer will produce
 undefined results)
 */
- (instancetype)initWithDiameter:(CGFloat)diameter;

/**
 Performant ways to set all of your options without redrawing the view on
 EACH property set.  (i.e. this will save upto 3 draw calls if you set all 4 options)
 Safe to pass nil to the circleColor, textColor and font args.
 */
-(void)batchUpdateViewWithInitials:(NSString *)initials circleColor:(UIColor *)circleColor textColor:(UIColor *)textColor font:(UIFont *)font;

@end
