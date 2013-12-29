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
#import "CHNFeedTableViewController.h"
#import "UIColor+HNColors.h"

@interface CHNEntriesTableViewController ()

@property (strong, nonatomic) HNSession *currentSession;
@property (strong, nonatomic) HNEntryList *submissions;
@property (nonatomic) int newsMode;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

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
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.color = [UIColor hnOrangeColor];
        CGRect aiFrame = self.activityIndicator.frame;
        CGRect tvFrame = self.navigationController.view.frame;
        aiFrame.origin.x = (tvFrame.size.width - aiFrame.size.width) / 2;
        aiFrame.origin.y = (tvFrame.size.height - aiFrame.size.height) / 2;
        self.activityIndicator.frame = aiFrame;
        [self.navigationController.view addSubview:self.activityIndicator];
    }
    [self.activityIndicator startAnimating];
    
    if (self.submissions.isLoading)
        [self.submissions cancelLoading];
    [self.submissions beginLoading];
}

- (IBAction)newsModeChanged:(UIStoryboardSegue *)sender
{
    CHNFeedTableViewController *source = sender.sourceViewController;
    if (source.newsMode == -1)
        return;
    self.newsMode = source.newsMode;
    
    switch (self.newsMode) {
    case 0:
        self.submissions.identifier =  kHNEntryListIdentifierSubmissions;
        self.navigationItem.title = @"Hacker News";
        break;
    case 1:
        self.submissions.identifier =  kHNEntryListIdentifierNewSubmissions;
        self.navigationItem.title = @"Newest";
        break;
    case 2:
        self.submissions.identifier =  kHNEntryListIdentifierAskSubmissions;
        self.navigationItem.title = @"Ask HN";
        break;
    case 3:
        self.submissions.identifier =  kHNEntryListIdentifierBestSubmissions;
        self.navigationItem.title = @"Best";
        break;
    default:
        break;
    }
    [self beginLoadingEntries:self];
}

- (void)submissionsStartedLoading:(NSNotification *)notification
{
    [self.tableView reloadData];
    NSLog(@"submissions loading... %@", notification.object);
}

- (void)submissionsFinishedLoading:(NSNotification *)notification
{
    NSLog(@"submissions loaded %@", notification.object);
    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
    [self.activityIndicator stopAnimating];
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
    if (self.submissions.isLoading)
        return 0;
    return self.submissions.entries.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.submissions.entries.count) {
        static NSString *LoadMoreEntriesCellId = @"CHNLoadMoreEntriesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreEntriesCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreEntriesCellId];
            cell.textLabel.text = @"Load More...";
            cell.textLabel.textColor = [UIColor hnOrangeColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CHNEntryTableViewCell"];

    HNEntry *entry = self.submissions.entries[indexPath.row];
    cell.textLabel.text = entry.title;
    NSString *detailText;
    detailText = [[NSString alloc] initWithFormat:@"%u %@ — %u %@ — %@",
                  entry.points, entry.points == 1 ? @"point" : @"points",
                  entry.children, entry.children == 1 ? @"comment" : @"comments",
                  entry.posted];
    if (entry.destination) {
        detailText = [[NSString alloc] initWithFormat:@"%@\n%@", detailText, entry.destination.host];
        cell.detailTextLabel.numberOfLines = 2;
    }
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.submissions.entries.count)
        return 44;
    HNEntry *entry = self.submissions.entries[indexPath.row];
    if (!entry.destination)
        return 44;
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath	 *)indexPath
{
    if (indexPath.row == self.submissions.entries.count) {
        NSLog(@"will load more");
        if (![self.submissions isLoadingMore])
            [self.submissions beginLoadingMore];
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        HNEntry *entry = self.submissions.entries[indexPath.row];
        self.entryViewController.entry = entry;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showArticle"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HNEntry *entry = self.submissions.entries[indexPath.row];
        NSLog(@"%@", [segue destinationViewController]);
        [[segue destinationViewController] setEntry:entry];
    } else if ([[segue identifier] isEqualToString:@"showFeedSelector"]) {
        CHNFeedTableViewController *feedSelector = [segue.destinationViewController childViewControllers][0];
        feedSelector.newsMode = self.newsMode;
    }
}

@end
