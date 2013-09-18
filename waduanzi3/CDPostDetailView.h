//
//  CDPostDetailView.h
//  waduanzi3
//
//  Created by chendong on 13-6-10.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDPostDetailView : UIView
{
    @private
    UIImageView *_videoIconView;;
}

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorTextLabel;
@property (nonatomic, strong) UILabel *datetimeTextLabel;

@property (nonatomic) CGFloat padding;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGFloat actualHeight;
@property (nonatomic) BOOL isVideo;


- (void) initSubViews;

@end
