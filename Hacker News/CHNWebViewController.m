//
//  CHNDetailViewController.m
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHNWebViewController.h"

#import <HNKit/HNKit.h>

@interface CHNWebViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation CHNWebViewController

#pragma mark - Managing the detail item

- (void)setEntry:(HNEntry *)entry
{
    if (_entry != entry) {
        _entry = entry;
        
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    if (self.entry) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.entry.destination];
        UIWebView *webView = (UIWebView *)self.view;
        [webView loadRequest:request];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)unwindToWebView:(UIStoryboardSegue *)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showComments"]) {
        [[segue destinationViewController] setEntry:self.entry];
    }
}

//#pragma mark - Split view
//
//- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
//{
//    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
//    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    self.masterPopoverController = popoverController;
//}
//
//- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
//    self.masterPopoverController = nil;
//}

@end
