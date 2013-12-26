//
//  CHNMasterViewController.m
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHNEntriesTableViewController.h"

#import <HNKit/HNKit.h>
#import "CHNWebViewController.h"

@interface CHNEntriesTableViewController ()

@property (strong, nonatomic) HNSession *currentSession;
@property (strong, nonatomic) HNEntryList *submissions;
@property (nonatomic) int newsMode;

@end

@implementation CHNEntriesTableViewController

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
    
    self.entryViewController = (CHNWebViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Fetch news!
    self.newsMode = 0;
    self.currentSession = [[HNAnonymousSession alloc] init];
    self.submissions = [HNEntryList session:self.currentSession entryListWithIdentifier:kHNEntryListIdentifierSubmissions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submissionsStartedLoading:) name:kHNObjectStartedLoadingNotification object:self.submissions];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submissionsFinishedLoading:) name:kHNObjectFinishedLoadingNotification object:self.submissions];
    
    [self beginLoadingEntries:self];
}

- (IBAction)beginLoadingEntries:(id)sender
{
    [self.submissions beginLoading];
}

- (IBAction)newsModeChanged:(UISegmentedControl *)sender
{
    if (self.submissions.isLoading)
        [self.submissions cancelLoading];
    
    self.newsMode = sender.selectedSegmentIndex;
    switch (self.newsMode) {
    case 0:
        self.submissions.identifier =  kHNEntryListIdentifierSubmissions;
        break;
    case 1:
        self.submissions.identifier =  kHNEntryListIdentifierNewSubmissions;
        break;
    case 2:
        self.submissions.identifier =  kHNEntryListIdentifierAskSubmissions;
        break;
        
    default:
        break;
    }
    [self beginLoadingEntries:self];
}

- (void)submissionsStartedLoading:(NSNotification *)notification
{
    NSLog(@"submissions loading... %@", notification.object);
}

- (void)submissionsFinishedLoading:(NSNotification *)notification
{
    NSLog(@"submissions loaded %@", notification.object);
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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
    NSString *detailText = [[NSString alloc] initWithFormat:@"%@ — %up — %uc — %@",
                            entry.destination.host,
                            entry.points, entry.children,
                            entry.posted];
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath	 *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        HNEntry *entry = self.submissions.entries[indexPath.row];
        self.entryViewController.entry = entry;
    }
    NSLog(@"row selected");
    [self performSegueWithIdentifier:@"showArticle" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showArticle"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HNEntry *entry = self.submissions.entries[indexPath.row];
        [[segue destinationViewController] setEntry:entry];
    }
}

@end
