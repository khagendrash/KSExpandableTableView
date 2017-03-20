//
//  Helpers.m
//  KSExpandableTableView
//
//  Created by Mac on 3/2/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

// set the backgroud color for status bar
+ (void) setStatusBarBackgroundColor {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    }
}

// get up/down arrow image
+ (UIImageView *) getArrow:(NSString *) arrowType
{
    UIImageView *ivArrowBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18.0, 18.0)];
    ivArrowBottom.image = [UIImage imageNamed:@"arrow-down"];
    
    if([arrowType isEqualToString:@"up"]){
        ivArrowBottom.image = [UIImage imageNamed:@"arrow-up"];
    }
    
    return ivArrowBottom;
}

@end
