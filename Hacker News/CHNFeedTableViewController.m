//
//  CHNFeedTableViewController.m
//  Hacker News
//
//  Created by Dr. G. von D. on 12/26/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHNFeedTableViewController.h"

@interface CHNFeedTableViewController ()

@end

@implementation CHNFeedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.newsMode) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = self.tableView.window.tintColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.newsMode inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.newsMode = indexPath.row;
    // Quickly update selected cell before unwinding
    [self tableView:tableView willDisplayCell:[tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"backToEntriesList" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIBarButtonItem class]])
        self.newsMode = -1;
}

@end
