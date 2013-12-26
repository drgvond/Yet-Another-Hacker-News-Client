//
//  CHNEntryTableViewCell.h
//  Hacker News
//
//  Created by Dr. G. von D. on 12/19/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHNEntryTableViewCell : UITableViewCell

@property (assign, nonatomic) NSString *hostName;
@property (assign, nonatomic) NSInteger *points;
@property (assign, nonatomic) NSInteger *comments;
@property (assign, nonatomic) NSString *datePosted;


@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *upVoteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
