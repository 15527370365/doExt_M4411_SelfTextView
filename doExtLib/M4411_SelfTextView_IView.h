//
//  M4411_SelfTextView_UI.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M4411_SelfTextView_IView <NSObject>

@required
//属性方法
- (void)change_angel:(NSString *)newValue;
- (void)change_enabled:(NSString *)newValue;
- (void)change_fontColor:(NSString *)newValue;
- (void)change_fontPath:(NSString *)newValue;
- (void)change_fontSize:(NSString *)newValue;
- (void)change_fontStyle:(NSString *)newValue;
- (void)change_heights:(NSString *)newValue;
- (void)change_image:(NSString *)newValue;
- (void)change_maxLength:(NSString *)newValue;
- (void)change_maxLines:(NSString *)newValue;
- (void)change_selected:(NSString *)newValue;
- (void)change_text:(NSString *)newValue;
- (void)change_widths:(NSString *)newValue;

//同步或异步方法
- (void)refreshSelf:(NSArray *)parms;

@end
