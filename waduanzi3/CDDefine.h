//
//  CDDefine.h
//  waduanzi3
//
//  Created by chendong on 13-6-7.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#ifndef waduanzi3_CDDefine_h
#define waduanzi3_CDDefine_h

#define FIRST_PAGE_ID 1


const static CGFloat DECK_LEFT_SIZE = 80.0f;

const static CGFloat POST_LIST_CELL_PADDING = 10.0f;
const static CGFloat POST_DETAIL_CELL_PADDING = 12.5f;
const static CGFloat THUMB_WIDTH = 150.0f;
const static CGFloat THUMB_HEIGHT = 150.0f;
const static CGFloat CELL_BUTTON_HEIGHT = 30.0f;
const static CGFloat POST_AVATAR_WIDTH = 30.0f;
const static CGFloat COMMENT_AVATAR_WIDTH = 24.0f;

const static CGFloat STATUSBAR_HEIGHT = 20.0f;
const static CGFloat NAVBAR_HEIGHT = 44.0f;
const static CGFloat TOOLBAR_HEIGHT = 44.0f;
const static CGFloat NAVBAR_LANDSCAPE_HEIGHT = 32.0f;
const static CGFloat AD_BANNER_HEIGHT = 50.0f;

// channel ID
const static NSInteger CHANNEL_FUNNY = 1;

// media type
const static NSInteger MEDIA_TYPE_MIXED = 0;
const static NSInteger MEDIA_TYPE_TEXT = 10;
const static NSInteger MEDIA_TYPE_IMAGE = 20;
const static NSInteger MEDIA_TYPE_AUDIO = 30;
const static NSInteger MEDIA_TYPE_VIDEO = 40;


// user login and signup
const static CGFloat VIEW_PADDING = 20.0f;
const static CGFloat LOGOVIEW_HEIGHT = 70.0f;
const static CGFloat FORMVIEW_HEIGHT = 90.0f;
const static CGFloat LOGOVIEW_FORMVIEW_MARGIN = 35.0f;
const static CGFloat LOGOVIEW_MARGIN_TOP = 90.0f;
const static CGFloat FORMVIEW_SUBMITBUTTON_MARGIN = 10.0f;
const static NSInteger USERNAME_TEXTFIELD_TAG = 1;
const static NSInteger PASSWORD_TEXTFIELD_TAG = 2;


typedef NS_ENUM(NSInteger, CDAppErrorCode) {
    USER_NOT_EXIST = 20001,
    USER_NOT_AUTHENTICATED = 20002,
};

#endif
