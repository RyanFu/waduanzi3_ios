//
//  CDDefine.h
//  waduanzi3
//
//  Created by chendong on 13-6-7.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#define CD_DEBUG YES

#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
#define CDDEVICE        [UIDevice currentDevice]
#define CDSCREEN        [UIScreen mainScreen]
#define CDSCREEN_SIZE   CDSCREEN.bounds.size
#define CDAPPLICATION   [UIApplication sharedApplication]
#define ROOT_CONTROLLER [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define APP_STORE_URL @"itms-apps://itunes.apple.com/cn/app//id486268988?mt=8"

#define MOGO_ADID  @"299f9bceb40a4aa785b6104d3d962378"
#define UMENG_APPKEY @"4ebd31185270156770000001"
#define WEIXIN_APPID @"wx22fe21179d1d00d0"
#define WEIXIN_APPKEY @"d0e57a648e5b3c4f1e518cf6c6185236"
#define OFFICIAL_SINA_WEIBO_USID @"1639121454"







#ifndef waduanzi3_CDDefine_h
#define waduanzi3_CDDefine_h

#define FIRST_PAGE_ID 1

#define DECK_LEFT_SIZE 80.0f

#define POST_LIST_CELL_FRAGMENT_PADDING 10.0f
#define POST_LIST_CELL_CONTENT_MARGIN UIEdgeInsetsMake(7.5f, 7.5f, 2.5f, 7.5f)
#define POST_LIST_CELL_CONTENT_PADDING UIEdgeInsetsMake(10.0f, 10.0f, 2.5f, 10.0f)
#define POST_DETAIL_CELL_PADDING 10.0f
#define THUMB_WIDTH 100.0f
#define THUMB_HEIGHT 130.0f
#define DETAIL_THUMB_HEIGHT 100.0f
#define CELL_BUTTON_HEIGHT 30.0f
#define POST_AVATAR_SIZE CGSizeMake(35.0f, 35.0f)
#define POST_BLOCK_SPACE_HEIGHT 5.0f
#define COMMENT_AVATAR_WIDTH 40.0f
#define COMMENT_BLOCK_SPACE_HEIGHT 5.0f

#define STATUSBAR_HEIGHT 20.0f
#define NAVBAR_HEIGHT 44.0f
#define TOOLBAR_HEIGHT 44.0f
#define NAVBAR_LANDSCAPE_HEIGHT 32.0f
#define AD_BANNER_HEIGHT 50.0f

// channel ID
#define CHANNEL_FUNNY 1

// media type
typedef NS_ENUM (NSInteger, CD_MEDIA_TYPE) {
    MEDIA_TYPE_MIXED=  0,
    MEDIA_TYPE_TEXT =  10,
    MEDIA_TYPE_IMAGE = 20,
    MEDIA_TYPE_AUDIO = 30,
    MEDIA_TYPE_VIDEO = 40
};


// user login and signup
#define VIEW_PADDING 20.0f
#define LOGOVIEW_HEIGHT 70.0f
#define FORMVIEW_HEIGHT 90.0f
#define LOGOVIEW_FORMVIEW_MARGIN 35.0f
#define LOGOVIEW_MARGIN_TOP 90.0f
#define FORMVIEW_SUBMITBUTTON_MARGIN 10.0f
#define USERNAME_TEXTFIELD_TAG 1
#define PASSWORD_TEXTFIELD_TAG 2

typedef NS_ENUM (NSInteger, CDUserError) {
    CDUserErrorUserNotExit = 20001,
    CDUserErrorUserNotAuthenticated = 20002
};

#endif







