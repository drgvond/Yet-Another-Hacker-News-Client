//
//  CHNMasterViewController.h
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHNDetailViewController;

@interface CHNMasterViewController : UITableViewController

@property (strong, nonatomic) CHNDetailViewController *detailViewController;

@end
