//
//  CHNEntryTableViewCell.m
//  Hacker News
//
//  Created by Dr. G. von D. on 12/19/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "CHNEntryTableViewCell.h"
#import "UIColor+HNColors.h"

#define kCatchWidth 120

@interface CHNEntryTableViewCell () <UIScrollViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setupView;

@property (nonatomic, weak) UIView *scrollViewContentView;        //The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;        //Contains our two buttons

@property (nonatomic, weak) UILabel *scrollViewLabel;

@property (nonatomic, assign) BOOL isShowingMenu;


@end

@implementation CHNEntryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        NSLog(@"Maybe not good");
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView
{
    self.moreButton.backgroundColor = [UIColor lightGrayColor];
    [self.moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.upVoteButton.backgroundColor = [UIColor hnOrangeColor];
    [self.upVoteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + 2 * CGRectGetWidth(self.moreButton.bounds), CGRectGetHeight(self.bounds));

    self.isShowingMenu = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0.0f, kCatchWidth, CGRectGetHeight(self.bounds))];
    self.scrollViewButtonView = scrollViewButtonView;
    [self.scrollView addSubview:scrollViewButtonView];
    
    // Set up our two buttons
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    moreButton.frame = CGRectMake(0.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollViewButtonView addSubview:moreButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.scrollViewContentView.bounds, 10.0f, 0.0f)];
    self.scrollViewLabel = scrollViewLabel;
    [self.scrollViewContentView addSubview:scrollViewLabel];
    
    
    // contentView
    //     scrollView
    //         scrollViewButtonView
    //             moreButton
    //             deleteButton
    //         scrollViewContentView
    //             scrollViewLabel
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
