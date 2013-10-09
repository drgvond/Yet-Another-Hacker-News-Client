//
//  CHNMasterViewController.h
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNWebViewController;

@interface CHNEntriesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CHNWebViewController *entryViewController;

@end
