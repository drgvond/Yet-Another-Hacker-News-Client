//
//  CHNCommentsViewController.h
//  Hacker News
//
//  Created by Dr. G. von D. on 10/9/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNEntry;

@interface CHNCommentsViewController : UITableViewController

@property (nonatomic) HNEntry *entry;

@end
