//
//  CHNDetailViewController.h
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNEntry;

@interface CHNWebViewController : UIViewController

@property (strong, nonatomic) HNEntry *entry;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
