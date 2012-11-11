//
//  AwfulTableViewController.m
//  Awful
//
//  Created by Sean Berry on 2/29/12.
//  Copyright (c) 2012 Regular Berry Software LLC. All rights reserved.
//

#import "AwfulTableViewController.h"
#import "AwfulSettings.h"
#import "SVPullToRefresh.h"

@implementation AwfulTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak AwfulTableViewController *blockSelf = self;
    if ([self canPullToRefresh]) {
        [self.tableView addPullToRefreshWithActionHandler:^{
            [blockSelf refresh];
        }];
    }
    if ([self canPullForNextPage]) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [blockSelf nextPage];
        }];
    }
    if ([self refreshOnAppear]) [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.networkOperation cancel];
    self.refreshing = NO;
    [super viewWillDisappear:animated];
}

- (void)refresh
{
    self.refreshing = YES;
}

- (void)nextPage
{
    self.refreshing = YES;
}

- (void)stop
{
    self.refreshing = NO;
}

- (void)setRefreshing:(BOOL)refreshing
{
    if (_refreshing == refreshing) return;
    _refreshing = refreshing;
    if (refreshing) {
        if ([self canPullToRefresh]) [self.tableView.pullToRefreshView startAnimating];
        if ([self canPullForNextPage]) [self.tableView.infiniteScrollingView startAnimating];
    } else {
        if ([self canPullToRefresh]) [self.tableView.pullToRefreshView stopAnimating];
        if ([self canPullForNextPage]) [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (BOOL)canPullToRefresh
{
    return YES;
}

- (BOOL)canPullForNextPage
{
    return NO;
}

- (BOOL)refreshOnAppear
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException
                format:@"Subclasses must implement %@", NSStringFromSelector(_cmd)];
}

@end
