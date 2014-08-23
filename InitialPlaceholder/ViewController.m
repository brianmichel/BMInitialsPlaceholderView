//
//  ViewController.m
//  InitialPlaceholder
//
//  Created by Brian Michel on 12/21/13.
//  Copyright (c) 2013 Brian Michel. All rights reserved.
//

#import "ViewController.h"
#import "BMInitialsPlaceholderView.h"

NSString * const kViewControllerCellIdentifier = @"cell";
const CGFloat kViewControllerCellHeight = 50.0;

@interface ViewController ()
@property (strong) NSArray *peopleArray;
@end

@implementation ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kViewControllerCellIdentifier];
        self.tableView.contentInset = self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        
        self.peopleArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"People" ofType:@"plist"]];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.peopleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kViewControllerCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kViewControllerCellIdentifier forIndexPath:indexPath];

    NSString *person = self.peopleArray[indexPath.row];
    
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0];
    CGFloat placeholderHW = kViewControllerCellHeight - 15;
    BMInitialsPlaceholderView *placeholder = [[BMInitialsPlaceholderView alloc] initWithDiameter:placeholderHW];
    //Option 1: Set each property separately.  This leads to wasted draws.
    //placeholder.font = font;
    //placeholder.initials = [self initialStringForPersonString:person];
    //placeholder.circleColor = [self circleColorForIndexPath:indexPath];
    
    //Option 2: Batch update the intials view setting all 4 options at once.  This will save up to 3 draw calls.
    [placeholder batchUpdateViewWithInitials:[self initialStringForPersonString:person]
                                 circleColor:[self circleColorForIndexPath:indexPath]
                                   textColor:[UIColor whiteColor]
                                        font:font];
    
    cell.textLabel.font = font;
    cell.textLabel.text = person;
    cell.accessoryView = placeholder;
    
    return cell;
}

- (UIColor *)circleColorForIndexPath:(NSIndexPath *)indexPath {
    return [UIColor colorWithHue:arc4random() % 256 / 256.0 saturation:0.7 brightness:0.8 alpha:1.0];
}

- (NSString *)initialStringForPersonString:(NSString *)personString {
    NSArray *comps = [personString componentsSeparatedByString:@" "];
    if ([comps count] >= 2) {
        NSString *firstName = comps[0];
        NSString *lastName = comps[1];
        return [NSString stringWithFormat:@"%@%@", [firstName substringToIndex:1], [lastName substringToIndex:1]];
    } else if ([comps count]) {
        NSString *name = comps[0];
        return [name substringToIndex:1];
    }
    return @"Unknown";
}

@end
