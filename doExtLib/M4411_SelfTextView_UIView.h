//
//  M4411_SelfTextView_View.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M4411_SelfTextView_IView.h"
#import "M4411_SelfTextView_UIModel.h"
#import "doIUIModuleView.h"

@interface M4411_SelfTextView_UIView : UIView<M4411_SelfTextView_IView, doIUIModuleView>
//可根据具体实现替换UIView
{
	@private
		__weak M4411_SelfTextView_UIModel *_model;
    
    UIFont *   _font;
    NSString * _text;
    int        _angel;
    UIColor *  _color;
    int        _fontSize;
    NSString * _fontName;
    NSString * _myFontFlag;
    NSString * _myFontStyle;
    BOOL       _selected;
    NSString * _image;
    BOOL _first;
    float _width;
    float _height;
    float _rate;
    CGAffineTransform _trans;
    
}

//- (void)drawOuterFrame:(CGContextRef )context;

@end
