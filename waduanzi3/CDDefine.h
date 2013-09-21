//
//  CDDefine.h
//  waduanzi3
//
//  Created by chendong on 13-6-7.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#ifdef DEBUG
#define CD_DEBUG YES
#else
#define CD_DEBUG NO
#endif


#ifndef waduanzi3_CDDefine_h
#define waduanzi3_CDDefine_h

#define DAY_SECONDS 86400

#define OPEN_UDID       [OpenUDID value]
#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
#define CDDEVICE        [UIDevice currentDevice]
#define CDSCREEN        [UIScreen mainScreen]
#define CDSCREEN_SIZE   CDSCREEN.bounds.size
#define CDAPPLICATION   [UIApplication sharedApplication]
#define ROOT_CONTROLLER [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define WDZ_APP_STORE_URL @"itms-apps://itunes.apple.com/cn/app//id486268988?mt=8"
#define OFFICIAL_SITE @"http://www.waduanzi.com";
#define OFFICIAL_MOBILE_SITE @"http://m.waduanzi.com";
#define APP_STORE_URL(APP_ID) [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app//id%@?mt=8", APP_ID]
#define APP_STORE_REVIEW_URL(APP_ID) [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APP_ID]

#define WADUANZI_APPLE_ID @"486268988"
#define MOGO_ADID  @"299f9bceb40a4aa785b6104d3d962378"
#define UMENG_APPKEY @"4ebd31185270156770000001"
#define UMAPPNETWORK_APPKEY @"4ebd31185270156770000001"
#define WEIXIN_APPID @"wx22fe21179d1d00d0"
#define WEIXIN_APPKEY @"d0e57a648e5b3c4f1e518cf6c6185236"
#define OFFICIAL_SINA_WEIBO_USID @"1639121454"
#define BAIDU_OPEN_API_KEY @"bGGXpA6v8UVnwdUEZkNgde4o"
#define BAIDU_OPEN_SECRET_KEY @"BtbYXKyVGiwT8toE3Mdiwpa1p00DbAqd"

// AD Publisher ID
#define AD_PUBLISHER_ID_DOMOB @"56OJyCLIuMPy+XankF"
#define DOMOB_PLACEMENT_ID_SPLASH_AD @"16TLwbCoAcIl2NUGozFAaq3i"



#define FIRST_PAGE_ID 1
#define POST_LIST_MAX_ROWS 200

#define DECK_LEFT_SIZE 80.0f

#define POST_LIST_CELL_FRAGMENT_PADDING 10.0f
#define POST_LIST_CELL_CONTENT_MARGIN UIEdgeInsetsMake(7.5f, 7.5f, 2.5f, 7.5f)
#define POST_LIST_CELL_CONTENT_PADDING UIEdgeInsetsMake(10.0f, 10.0f, 2.5f, 10.0f)
#define POST_DETAIL_CELL_PADDING 10.0f
#define THUMB_WIDTH 100.0f
#define THUMB_HEIGHT 130.0f
#define VIDEO_THUMB_SIZE CGSizeMake(130.0f, 100.0f)
#define POST_DETAIL_VIDEO_THUMB_HEIGHT 150.0f
#define DETAIL_THUMB_HEIGHT 100.0f
#define CELL_BUTTON_HEIGHT 30.0f
#define POST_AVATAR_SIZE CGSizeMake(35.0f, 35.0f)
#define POST_LIST_CELL_BOTTOM_BUTTON_HEIGHT 30.0f
#define POST_BLOCK_SPACE_HEIGHT 5.0f
#define COMMENT_AVATAR_WIDTH 40.0f
#define COMMENT_BLOCK_SPACE_HEIGHT 5.0f
#define SHOW_LONG_IMAGE_ICON_MAX_HEIGHT 1500.0f // pixel

#define STATUSBAR_HEIGHT 20.0f
#define NAVBAR_HEIGHT 44.0f
#define TOOLBAR_HEIGHT 44.0f
#define NAVBAR_LANDSCAPE_HEIGHT 32.0f
#define AD_BANNER_HEIGHT 50.0f

// channel ID
typedef NS_ENUM (NSInteger, CD_CHANNEL) {
    CHANNEL_FUNNY = 1,
    CHANNEL_FOCUS = 2
};

// media type
typedef NS_ENUM (NSInteger, CD_MEDIA_TYPE) {
    MEDIA_TYPE_MIXED=  0,
    MEDIA_TYPE_TEXT =  10,
    MEDIA_TYPE_IMAGE = 20,
    MEDIA_TYPE_AUDIO = 30,
    MEDIA_TYPE_VIDEO = 40
};

#define SUPPORT_MEDIA_TYPES [NSString stringWithFormat:@"%d,%d,%d", MEDIA_TYPE_TEXT, MEDIA_TYPE_IMAGE, MEDIA_TYPE_VIDEO]

// user login and signup
#define VIEW_PADDING 20.0f
#define LOGOVIEW_HEIGHT 70.0f
#define FORMVIEW_HEIGHT 90.0f
#define LOGOVIEW_FORMVIEW_MARGIN 35.0f
#define LOGOVIEW_MARGIN_TOP 90.0f
#define FORMVIEW_SUBMITBUTTON_MARGIN 10.0f
#define USERNAME_TEXTFIELD_TAG 1
#define PASSWORD_TEXTFIELD_TAG 2

typedef NS_ENUM (NSInteger, CDUserLoginError) {
    CDUserLoginErrorUserNotExit = 20001,
    CDUserLoginErrorUserNotAuthenticated = 20002,
    CDUserloginErrorUserNameInvalid = 20010
};

typedef NS_ENUM (NSInteger, CDUserSignupError) {
    CDUserSignupErrorAccountInvalid = 20010,
    CDUserSignupErrorAccountExist = 20011
};

typedef NS_ENUM (NSInteger, CDUpdateUserProfileError) {
    CDUpdateUserProfileErrorNickExist = 20021
};

typedef NS_ENUM (NSInteger, CDCommentContentFontSize)
{
    CDCommentContentFontSizeSmall = 12,
    CDCommentContentFontSizeNormal = 14,
    CDCommentContentFontSizeBig = 16
};

typedef NS_ENUM (NSUInteger, CDPostContentFontSize)
{
    CDPostContentFontSizeSmall = 14,
    CDPostContentFontSizeNormal = 16,
    CDPostContentFontSizeBig = 18,
    CDPostContentFontSizeBigBig = 22
};


#define USER_NAME_MIN_LENGTH 3
#define USER_NAME_MAX_LENGTH 30
#define USER_PASSWORD_MIN_LENGTH 3
#define USER_PASSWORD_MAX_LENGTH 30

#define FZLTHK_FONT_FAMILY @"FZLanTingHei-R-GBK"
#define FZLTHK_FONT_NAME @"FZLTHK--GBK1-0"



/*
 *  System Versioning Preprocessor Macros
 */
#define OS_VERSION_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedSame)
#define OS_VERSION_GREATER_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedDescending)
#define OS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)
#define OS_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedAscending)
#define OS_VERSION_LESS_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedDescending)


#endif





