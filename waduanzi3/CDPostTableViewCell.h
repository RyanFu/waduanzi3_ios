//
//  CDPostTableViewCell.h
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDPostTableViewCellDelegate <NSObject>

@optional
- (void) thumbImageViewDidTapFinished:(UITapGestureRecognizer *) gestureRecognizer;
- (void) avatarImageViewDidTapFinished:(UITapGestureRecognizer *) gestureRecognizer;
- (void) videoImageViewDidTapFinished:(UITapGestureRecognizer *) gestureRecognizer;
@end



@interface CDPostTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CDPostTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorTextLabel;
@property (nonatomic, strong) UILabel *datetimeTextLabel;
@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) UIEdgeInsets contentPadding;

@property (nonatomic, assign) CGFloat separatorHeight;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) BOOL isAnimatedGIF;
@property (nonatomic, assign) BOOL isLongImage;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL showGIFIcon;
@property (nonatomic, assign) BOOL showLongIcon;

- (CGFloat) realHeight;
- (CGFloat) contentBlockWidth;

@end

