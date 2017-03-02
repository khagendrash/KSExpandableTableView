//
//  ViewController.h
//  KSExpandableTableView
//
//  Created by Mac on 3/2/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property NSArray *arrayKeys;
@property NSDictionary *dictTempItems;
@property NSDictionary *dictOriginalItems;
@property NSMutableArray *arrayOfIndexPaths;


@end

