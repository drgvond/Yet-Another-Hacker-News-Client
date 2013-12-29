//
//  UIColor+HNColors.m
//  Hacker News
//
//  Created by Dr. G. von D. on 9/28/13.
//  Copyright (c) 2013 Chouette Labs. All rights reserved.
//

#import "UIColor+HNColors.h"

@implementation UIColor (HNColors)

+ (UIColor *)hnOrangeColor
{
    // Header color from https://news.ycombinator.com is #ff6600
    return [UIColor colorWithRed:1.0 green:102.0/255.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)hnDarkOrangeColor
{
    // Header color from https://news.ycombinator.com is #ff6600
    return [UIColor colorWithRed:190.0/255.0 green:105.0/255.0 blue:55.0/255.0 alpha:1.0];
}

@end
