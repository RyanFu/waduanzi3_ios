//
//  CDDefine.h
//  waduanzi3
//
//  Created by chendong on 13-6-7.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UMSocial.h"

#ifdef DEBUG
#define CD_DEBUG YES
#else
#define CD_DEBUG NO
#endif


#ifndef waduanzi3_CDDefine_h
#define waduanzi3_CDDefine_h

#define DAY_SECONDS 86400
#define DAYS_AUTO_CLEAR_CACHE_FILES 7

#define OPEN_UDID       [OpenUDID value]
#define USER_DEFAULTS   [NSUserDefaults standardUserDefaults]
#define CDDEVICE        [UIDevice currentDevice]
#define CDSCREEN        [UIScreen mainScreen]
#define CDSCREEN_SIZE   CDSCREEN.bounds.size
#define CDAPPLICATION   [UIApplication sharedApplication]
#define ROOT_CONTROLLER [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define ROOT_DECK_CONTROLLER (IIViewDeckController *)ROOT_CONTROLLER
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define CURRENT_NETWORK_STATUS [RKObjectManager sharedManager].HTTPClient.networkReachabilityStatus
#define NETWORK_STATUS_IS_WIFI (CURRENT_NETWORK_STATUS == AFNetworkReachabilityStatusReachableViaWiFi)
#define NETWORK_STATUS_IS_WWAN (CURRENT_NETWORK_STATUS == AFNetworkReachabilityStatusReachableViaWWAN)
#define POST_LIST_SHOW_BIG_IMAGE (NETWORK_STATUS_IS_WIFI && [CDUserConfig shareInstance].wifi_big_image) || (NETWORK_STATUS_IS_WWAN && [CDUserConfig shareInstance].wwan_big_image)

#define HTTP_REST_REQUEST_REFERRE @"http://ios.apps.waduanzi.com/"
#define HTTP_IMAGE_REQUEST_REFERR @"http://img.apps.waduanzi.com/"
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
#define QQ_CONNECT_APPID @"100490326"
#define QQ_WEIBO_APPID @"801092195"


// AD Publisher ID
#define AD_PUBLISHER_ID_DOMOB @"56OJyCLIuMPy+XankF"
#define DOMOB_PLACEMENT_ID_SPLASH_AD @"16TLwbCoAcIl2NUGozFAaq3i"



#define FIRST_PAGE_ID 1
#define POST_LIST_MAX_ROWS 60

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

// webview advert
#define NORMAL_BANNER_AD_SIZE CGSizeMake(320.0f, 50.0f)
#define CUSTOM_AD_VIDEO_WEBVIEW_SIZE CGSizeMake(320.0f, 150.0f)

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

typedef NS_ENUM(NSInteger, CDImageHeightFilter)
{
    CDImageHeightFilterDisabled = -1,
    CDImageHeightFilterOnlyShort = 0,
    CDImageHeightFilterOnlyLong = 1
};

#define POP_NAVIGATION_CONTROLLER_GESTURE_RECOGNIZER_VIEW_TAG 9999

#define USER_NAME_MIN_LENGTH 3
#define USER_NAME_MAX_LENGTH 30
#define USER_PASSWORD_MIN_LENGTH 5
#define USER_PASSWORD_MAX_LENGTH 30

#define FZLTHK_FONT_FAMILY @"FZLanTingHei-R-GBK"
#define FZLTHK_FONT_NAME @"FZLTHK--GBK1-0"
#define POST_TEXT_COLOR [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.00f]
#define COMMENT_TEXT_COLOR [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f]

#define PLACEHOLDER_IMAGE_AVATAR [UIImage imageNamed:@"timeline_AvatarPlaceholderMale"]
#define PLACEHOLDER_IMAGE_POST_THUMB [UIImage imageNamed:@"thumb_placeholder"]
#define PLACEHOLDER_IMAGE_LIGHTGRAY_THUMB [UIImage imageWithColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f] size:CGSizeMake(1, 1)]


/*
 *  System Versioning Preprocessor Macros
 */
#define OS_VERSION_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedSame)
#define OS_VERSION_GREATER_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedDescending)
#define OS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)
#define OS_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedAscending)
#define OS_VERSION_LESS_THAN_OR_EQUAL_TO(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedDescending)

#define IS_IOS7 OS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#endif


/*
 * 多盟统计事件ID
 */

#define UM_EVENT_MENU_TIMELINE @"v3_menu_timeline"
#define UM_EVENT_MENU_RECOMMEND @"v3_menu_recommend"
#define UM_EVENT_MENU_HISTORY @"v3_menu_history"
#define UM_EVENT_MENU_MEDIA_TEXT @"v3_menu_media_text"
#define UM_EVENT_MENU_MEDIA_IMAGE @"v3_menu_media_image"
#define UM_EVENT_MENU_MEDIA_LONG_IMAGE @"v3_menu_media_long_image"
#define UM_EVENT_MENU_MEDIA_VIDEO @"v3_menu_media_video"
#define UM_EVENT_MENU_CHANNEL_FOCUS @"v3_menu_channel_focus"
#define UM_EVENT_MENU_MY_FAVORITE @"v3_menu_my_favorite"
#define UM_EVENT_MENU_MY_COMMENT @"v3_menu_my_comment"
#define UM_EVENT_MENU_MY_SHARE @"v3_menu_my_share"
#define UM_EVENT_MENU_APP_RECOMMEND @"v3_menu_tab_app_recommend"
#define UM_EVENT_GOTO_COMMENT_LIST @"v3_goto_comments_list"
#define UM_EVENT_FAVORITE_POST @"v3_favorite_button_clicked"
#define UM_EVENT_LIKE_POST @"v3_like_button_clicked"
#define UM_EVENT_POST_COMMENT @"v3_post_comment"
#define UM_EVENT_PLAY_VIDEO @"v3_play_video"

#define UM_ONLINE_CONFIG_APP_UNION_HANLE @"enable_umhandle"
#define UM_ONLINE_CONFIG_ENABLE_FOCUS_LIST_BANNER @"v3_focus_list_banner_ad_enable"
#define UM_ONLINE_CONFIG_SHOW_APP_RECOMMEND_TAB @"v3_show_app_recommend_tab"


/*
 * 多盟社会化组伯
 */


#define UMShareToCopy @"um_platform_copy"

typedef NS_ENUM (NSInteger, UMShareToTypeExtend) {
    UMSocialSnsTypeCopy = 999
};


/*
 * 百度云推送固定tag
 */

#define BAIDU_PUSH_TAG_HAS_LOGINED @"has_logined"
#define BAIDU_PUSH_TAG_NOT_LOGINED @"not_logined"






