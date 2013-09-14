//
//  CDPostTableViewCell.h
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDAdvertTableViewCellDelegate <NSObject>

@optional
- (void) advertImageViewDidTapFinished:(UITapGestureRecognizer *) gestureRecognizer;
- (void) DownloadButtonDidClickedFinished:(UITapGestureRecognizer *) gestureRecognizer;
@end

@interface CDAdvertTableViewCell : UITableViewCell {
    
@private
    UIView *_installView;
}

@property (nonatomic, weak) id<CDAdvertTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorTextLabel;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UIButton  *installButton;

@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) UIEdgeInsets contentPadding;

@property (nonatomic) CGFloat separatorHeight;

- (CGFloat) realHeight;

@end

