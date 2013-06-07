//
//  CDPostTableViewCell.h
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDCommentTableViewCellDelegate <NSObject>

@optional

@end



@interface CDCommentTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CDCommentTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorTextLabel;
@property (nonatomic, strong) UILabel *orderTextLabel;

@property (nonatomic) CGFloat padding;

@end

