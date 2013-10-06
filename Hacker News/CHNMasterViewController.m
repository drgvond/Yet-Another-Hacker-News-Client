//
//  CHNMasterViewController.m
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHNMasterViewController.h"

#import <HNKit/HNKit.h>
#import "CHNDetailViewController.h"

@interface CHNMasterViewController ()

@property (strong, nonatomic) HNSession *currentSession;
@property (strong, nonatomic) HNEntryList *submissions;

@end

@implementation CHNMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TODO Add burger button instead
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // TODO This one's for new submissions. Only visible if actual user, or ask to sign in.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (CHNDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Fetch news!
    self.currentSession = [[HNAnonymousSession alloc] init];
    self.submissions = [HNEntryList session:self.currentSession entryListWithIdentifier:kHNEntryListIdentifierSubmissions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submissionsStartedLoading:) name:kHNObjectStartedLoadingNotification object:self.submissions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submissionsFinishedLoading:) name:kHNObjectFinishedLoadingNotification object:self.submissions];
    
    [self.submissions beginLoading];
}

- (void)submissionsStartedLoading:(NSNotification *)notification
{
    NSLog(@"submissions loading... %@", notification.object);
}

- (void)submissionsFinishedLoading:(NSNotification *)notification
{
    NSLog(@"submissions loaded %@", notification.object);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.submissions.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CHNEntryTableViewCell"];

    HNEntry *entry = self.submissions.entries[indexPath.row];
    cell.textLabel.text = entry.title;
    NSString *detailText = [[NSString alloc] initWithFormat:@"%@ — %u %@ — %@ ago",
                            entry.destination.host,
                            entry.points, (entry.points == 1 ? @"point" : @"points"),
                            entry.posted];
    cell.detailTextLabel.text = detailText;
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        HNEntry *entry = self.submissions.entries[indexPath.row];
        self.detailViewController.entry = entry;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HNEntry *entry = self.submissions.entries[indexPath.row];
        [[segue destinationViewController] setEntry:entry];
    }
}

@end
