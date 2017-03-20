//
//  ViewController.m
//  KSExpandableTableView
//
//  Created by Mac on 3/2/17.
//  Copyright © 2017 Home. All rights reserved.
//

#import "MainController.h"
#import "Helpers.h"
#import "Constants.h"


// Table cell Identifier
static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";


@interface MainController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialization
    [self myInitialization];
    
    // change the status bar backgound color
    [Helpers setStatusBarBackgroundColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// do some initialization
-(void) myInitialization
{
    // The keys that are displayed as section title
    self.arrayKeys = @[PLANETS,INSTRUMENTS,PHONES,FRUITS,SAARC];
    
    
    // Model that contain all the items in each key/section
    self.dictOriginalItems = @{
                               PLANETS : @[@"Mars",@"Jupiter",@"Mercury",@"Satrun",@"Venus",@"Earth",@"Uranus",@"Neptune"],
                               
                               INSTRUMENTS : @[@"Guitar",@"Piano",@"Violin",@"Trumpet",@"Flute",@"Saxophone"],
                               
                               PHONES : @[@"Iphone",@"Android",@"Windows"],
                               
                               FRUITS : @[@"Apple",@"Orange",@"Grapes",@"Mango",@"Cherry",@"Banana"],
                               
                               SAARC : @[@"Afganistan",@"Bangladesh",@"Bhutan",@"India",@"Maldives",@"Nepal",@"Pakistan",@"Sri Lanka"]
                               };
    
    
    // The temporary model to show minimum items. The number of items in each key should be equal to the value set for MIN_ROW_IN_SECTION (see constant variable declaration)
    self.dictTempItems = @{
                           PLANETS : @[@"Mars",@"Jupiter",@"Mercury"],
                           INSTRUMENTS : @[@"Guitar",@"Piano",@"Violin"],
                           PHONES : @[@"Iphone",@"Android",@"Windows"],
                           FRUITS : @[@"Apple",@"Orange",@"Grapes"],
                           SAARC : @[@"Afganistan",@"Bangladesh",@"Bhutan"]
                        };
    
    
    if(self.arrayOfIndexPaths == nil){
        self.arrayOfIndexPaths = [NSMutableArray arrayWithCapacity:40];
    }
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrayKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.arrayKeys[section];
    NSArray *arrItems = self.dictTempItems[key];
    
    NSUInteger curItemCount = [arrItems count];
    NSUInteger origItemCount = [[self.dictOriginalItems objectForKey:key] count];
    
    
    if(origItemCount > curItemCount){
        // one extra cell for more tab
        return [arrItems count] + 1;
    }
    else if(origItemCount == curItemCount && curItemCount > MIN_ROW_IN_SECTION){
        // one extra cell less tab
        return [arrItems count] + 1;
    }
    else{
        // no extra cell as there is no more and less tab
        return [arrItems count];
    }
}

// Returns the title of each section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.arrayKeys[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    
    NSString *key = self.arrayKeys[indexPath.section];
    NSArray *arrItems = self.dictTempItems[key];
    
    NSUInteger curItemCount = [arrItems count];
    
    if(indexPath.row == curItemCount){
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.44f green:0.13f blue:0.51f alpha:1.0f];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        
        // if there is extra cell, then add text 'more/less' in extra cell
        if(![self.arrayOfIndexPaths containsObject:[NSNumber numberWithInteger:indexPath.section]]){
            cell.textLabel.text = @"More";
            cell.textLabel.tag = TAG_FOR_ROW_MORE;
            
            // add down arrow
            cell.accessoryView = [Helpers getArrow:@"down"];
        }
        else{
            cell.textLabel.text = @"Less";
            cell.textLabel.tag = TAG_FOR_ROW_LESS;
            
            // add up arrow
            cell.accessoryView = [Helpers getArrow:@"up"];
        }
    }
    else{
        // cell contains the normal value
        NSString *itemValue = (NSString *) arrItems[indexPath.row];
        cell.textLabel.text = itemValue;
        cell.textLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    }
    
    return cell;
}

// Delegate method when a more/Less row is clicked
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // make cell unselected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSString *key = self.arrayKeys[indexPath.section];
    
    
    // get the cell row selected
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSUInteger tagValue = cell.textLabel.tag;
    
    
    // handle table cell row clicked for more/less
    if(tagValue == TAG_FOR_ROW_LESS || tagValue == TAG_FOR_ROW_MORE){
        
        // get array of all items
        NSArray *arrOriginalItems = [self.dictOriginalItems objectForKey:key];
        NSMutableDictionary *dictItems = [self.dictTempItems mutableCopy];
        
        
        // array of items to be added or removed from a table section
        NSArray *arrNew = [arrOriginalItems subarrayWithRange:NSMakeRange(MIN_ROW_IN_SECTION, [arrOriginalItems count] - MIN_ROW_IN_SECTION)];
        
        // add the current clicked index path
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:10];
        for (int ix = 0; ix < [arrNew count]; ix++) {
            NSIndexPath* ip = [NSIndexPath indexPathForRow:(MIN_ROW_IN_SECTION + ix) inSection:indexPath.section];
            [arr addObject: ip];
        }
        
        // handle when row for more is selected
        if(![self.arrayOfIndexPaths containsObject:[NSNumber numberWithInteger:indexPath.section]]){
            
            // add arrow up
            cell.accessoryView = [Helpers getArrow:@"up"];
            cell.textLabel.text = @"Less";
            [self.arrayOfIndexPaths addObject:[NSNumber numberWithInteger:indexPath.section]];
            
            // update data source
            [dictItems setObject:arrOriginalItems forKey:key];
            self.dictTempItems = [NSDictionary dictionaryWithDictionary:dictItems];
            
            // update table by inserting rows
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
        else if([self.arrayOfIndexPaths containsObject:[NSNumber numberWithInteger:indexPath.section]]){
            
            // add arrow down
            cell.accessoryView = [Helpers getArrow:@"down"];
            cell.textLabel.text = @"More";
            [self.arrayOfIndexPaths removeObject:[NSNumber numberWithInteger:indexPath.section]];
            
            // update data source with only the minimum numbers of rows to be displayed
            NSArray *arrSub = [arrOriginalItems subarrayWithRange:NSMakeRange(0, MIN_ROW_IN_SECTION)];
            [dictItems setObject:arrSub forKey:key];
            self.dictTempItems = [NSDictionary dictionaryWithDictionary:dictItems];
            
            // upadate table by removing rows
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
    else{
        // Statements for row selected other than more/less
        
        NSLog(@"Other than more/less row clicked");
    }
}

@end
