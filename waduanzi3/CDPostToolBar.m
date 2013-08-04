//
//  CDPostself.m
//  waduanzi3
//
//  Created by chendong on 13-7-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDPostToolBar.h"

@implementation CDPostToolBar

@synthesize likeButton = _likeButton;
@synthesize favoriteButton = _favoriteButton;
@synthesize commentButton = _commentButton;
@synthesize actionButton = _actionButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
        CALayer *topLayer = [CALayer layer];
        topLayer.frame = CGRectMake(0, 0, frame.size.width, 1.0f);
        topLayer.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f].CGColor;
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, frame.size.height-1.0f, frame.size.width, 1.0f);
        bottomLayer.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f].CGColor;
        [self.layer addSublayer:topLayer];
        [self.layer addSublayer:bottomLayer];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_likeButton];
        [self addSubview:_favoriteButton];
        [self addSubview:_commentButton];
        [self addSubview:_actionButton];
        
        [_likeButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Like_Normal.png"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Like_Highlighted.png"] forState:UIControlStateHighlighted];
        [_likeButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Like_Selected.png"] forState:UIControlStateSelected];
//        [_favoriteButton setImage:[UIImage imageNamed:@"starunread.png"] forState:UIControlStateNormal];
//        [_favoriteButton setImage:[UIImage imageNamed:@"starread.png"] forState:UIControlStateSelected];
        [_favoriteButton setImage:[UIImage imageNamed:@"starEmpty.png"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"starFull.png"] forState:UIControlStateSelected];

        [_commentButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Comment_Normal.png"] forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Comment_Highlighted.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
        [_actionButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Share_Normal.png"] forState:UIControlStateNormal];
        [_actionButton setImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_Icon_Share_Highlighted.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"newsfeed_StoryFeedback_MiddleBackground_Highlighted.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
        
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likeButton setTitle:@"已赞" forState:UIControlStateSelected];
        [_favoriteButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_favoriteButton setTitle:@"已收藏" forState:UIControlStateSelected];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_actionButton setTitle:@"分享" forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_favoriteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _likeButton.titleLabel.font = _favoriteButton.titleLabel.font = _commentButton.titleLabel.font = _actionButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _likeButton.titleEdgeInsets = _favoriteButton.titleEdgeInsets = _commentButton.titleEdgeInsets = _actionButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 0);
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonHeight = self.bounds.size.height;
    CGFloat buttonWidth = self.bounds.size.width / 4;
    
    CGRect buttonFrame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    buttonFrame.size.width = buttonWidth;
    _likeButton.frame = buttonFrame;
    
    buttonFrame.origin.x += buttonWidth;
    _favoriteButton.frame = buttonFrame;
    
    buttonFrame.origin.x += buttonWidth;
    _commentButton.frame = buttonFrame;
    
    buttonFrame.origin.x += buttonWidth;
    _actionButton.frame = buttonFrame;
    
}


@end
