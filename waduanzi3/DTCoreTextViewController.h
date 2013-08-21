//
//  DTCoreTextViewController.h
//  waduanzi3
//
//  Created by chendong on 13-8-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@interface DTCoreTextViewController : UIViewController <DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
{
    DTAttributedTextView *_coreTextView;
}
@end
