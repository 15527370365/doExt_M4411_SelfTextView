//
//  M4411_SelfTextView_Model.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "M4411_SelfTextView_UIModel.h"
#import "doProperty.h"

@implementation M4411_SelfTextView_UIModel

#pragma mark - 注册属性（--属性定义--）
/*
[self RegistProperty:[[doProperty alloc]init:@"属性名" :属性类型 :@"默认值" : BOOL:是否支持代码修改属性]];
 */
-(void)OnInit
{
    [super OnInit];    
    //属性声明
    [self RegistProperty:[[doProperty alloc]init:@"angel" :Number :@"0" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"enabled" :Bool :@"true" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontColor" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontPath" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontSize" :Number :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontStyle" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"heights" :Number :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"image" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"maxLength" :Number :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"maxLines" :Number :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"selected" :Bool :@"true" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"text" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"widths" :Number :@"" :NO]];

}

@end
