//
//  M4411_SelfTextView_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "M4411_SelfTextView_UIView.h"

#import "doIPage.h"
#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "CoreText/CoreText.h"
#import "doIOHelper.h"

#define BODER 0 //边距
#define DIAMETER 20 //直径
#define FONT_OBLIQUITY 15.0


@implementation M4411_SelfTextView_UIView
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象

- (void) LoadView: (doUIModule *) _doUIModule
{

    _model = (typeof(_model)) _doUIModule;
    
    _text = [(doUIModule *)_model GetProperty:@"text"].DefaultValue;
    _fontSize = 12;
    _font = [UIFont systemFontOfSize: _fontSize ];//定义默认字体
    _angel = 0;
    _selected = NO;
    _first = YES;
    _color = [UIColor redColor];
    
    [self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
}
//销毁所有的全局对象
- (void) OnDispose
{
    //自定义的全局属性,view-model(UIModel)类销毁时会递归调用<子view-model(UIModel)>的该方法，将上层的引用切断。所以如果self类有非原生扩展，需主动调用view-model(UIModel)的该方法。(App || Page)-->强引用-->view-model(UIModel)-->强引用-->view
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改,如果添加了非原生的view需要主动调用该view的OnRedraw，递归完成布局。view(OnRedraw)<显示布局>-->调用-->view-model(UIModel)<OnRedraw>
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}


- (void)drawRect:(CGRect)rect
{
    [self setTransform:CGAffineTransformIdentity];//每次画布之前需要先旋转回来，在原始位置的基础上操作，不然取的位置会有问题
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    if (_first){
        //_image的UIImageView
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER))];
        image.tag = 101;
        image.hidden = true;
        [self addSubview:image];
        
        //左上角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(BODER, BODER, DIAMETER, DIAMETER)];
        image.tag = 401;
        image.hidden = true;
        image.image = [UIImage imageNamed:@"delete"];
//        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/1.png" ]];
        [self addSubview:image];
        
        //左下角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(BODER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];
        image.tag = 402;
        image.hidden = true;
        image.image = [UIImage imageNamed:@"transform"];
//        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/2.png" ]];
        [self addSubview:image];
        
        //右下角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];
        image.tag = 403;
        image.hidden = true;
        image.image = [UIImage imageNamed:@"cross_move"];
//        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/3.png" ]];
        [self addSubview:image];
        
        
        //右上角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(w-BODER-DIAMETER, BODER, DIAMETER, DIAMETER)];
        image.tag = 404;
        image.hidden = true;
        image.image = [UIImage imageNamed:@"5"];
//        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/5.png" ]];
        [self addSubview:image];
        _first = NO;
    }
    
    //CGContextRef context=UIGraphicsGetCurrentContext();//设置一个空白view，准备画画
    
    UIFont  *font ;
    if( _font == NULL)
        font = [UIFont systemFontOfSize:12.0];
    else
        font = _font;
    if( _color == NULL )
        _color = [UIColor redColor];
    
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    NSDictionary* attribute = @{
                                NSForegroundColorAttributeName: _color,//设置文字颜色
                                NSFontAttributeName:font,//设置文字的字体
                                NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                                };
    UIImageView *select_image = [self viewWithTag:403];
    
    if( _image!= NULL && ![_image isEqualToString:@""] )
    {
         //  你 转化成本地路径，画出来 self.bounds
        UIImageView *image = [self viewWithTag:101];
        image.image = [UIImage imageNamed:_image];
//        image.image = [UIImage imageWithContentsOfFile:_image];
        image.hidden = false;
        select_image.image = [UIImage imageNamed:@"move"];
//        select_image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/4.png" ]];
    }else{
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        //在内部矩形显示文字
        CGRect textDispRect = CGRectMake( BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER));
        [_text drawInRect:textDispRect withAttributes:attribute];
        select_image.image = [UIImage imageNamed:@"cross_move"];
//        select_image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/3.png" ]];
        UIImageView *image = [self viewWithTag:101];
        image.hidden = true;
    }
    
    
    
    // 选中时，显示提示文字
    if( _selected ) {
       
        NSString * indicator = @"双击编辑";
        
        //计算文字的宽度和高度：支持多行显示
        
        UIFont  * indiFont = [UIFont systemFontOfSize:12.0];
        
        CGSize sizeText = [indicator boundingRectWithSize:self.bounds.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName:indiFont,//文字的字体
                                                            }
                                                  context:nil].size;
        
        attribute = @{
                      NSForegroundColorAttributeName: _color,//设置文字颜色
                      NSFontAttributeName:indiFont,//设置文字的字体
                      NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
                      };
        int beginx = (w-sizeText.width)/2;
        if( beginx<0 )
            beginx = 0;
        CGRect indiDispRect = CGRectMake(beginx, 0, sizeText.width, sizeText.height );
        [indicator drawInRect:indiDispRect withAttributes:attribute];
        
        //显示操作提示图标
        [self viewWithTag:401].hidden = true;
        [self viewWithTag:402].hidden = true;
        
        //画虚线
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        //设置线条样式
        CGContextSetLineCap(context, kCGLineCapButt);
        //设置线条粗细宽度
        CGContextSetLineWidth(context, 1.0);
        //设置颜色
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.92 green:0.78 blue:0.38 alpha:1].CGColor);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置:左上角
        CGContextMoveToPoint(context, BODER+DIAMETER/2, BODER+DIAMETER/2);
        
        //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
        CGFloat arr[] = {10,5};
        //下面最后一个参数“2”代表排列的个数。
        CGContextSetLineDash(context, 0, arr, 2);
        

        
        //设置下一个坐标点：左下角
        CGContextAddLineToPoint(context, BODER+DIAMETER/2, h - (BODER+DIAMETER/2));
        //设置下一个坐标点：右下角
        CGContextAddLineToPoint(context, w - (BODER+DIAMETER/2), h - (BODER+DIAMETER/2));
        //设置下一个坐标点：右上角
        CGContextAddLineToPoint(context, w - (BODER+DIAMETER/2), BODER+DIAMETER/2);
        //设置下一个坐标点：左上角
        CGContextAddLineToPoint(context, BODER+DIAMETER/2, BODER+DIAMETER/2);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
        
    }
    for (int i=401; i<=404; i++) {
        [self viewWithTag:i].hidden = !_selected;
    }
    
    
    if (_angel != 0)
    {

        [self setTransform:CGAffineTransformMakeRotation( _angel * M_PI/180.0) ];
        //[self setTransform:CGAffineTransformRotate(self.transform, (_angel * M_PI/180.0))];
        //_angel = 0;  //如果不清零，会不停旋转
    }
}


//// 画外边框
//- (void)drawOuterFrame:(CGContextRef )context
//{
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    CGRect textDispRect = CGRectMake( 10, 10, width - 20, height - 20);
//    
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);//设置当前笔头颜色
//    CGContextSetLineWidth(context, 1.0);//设置当前画笔粗细
//    CGContextAddRect(context, textDispRect);//设置一个终点
//    
//    UIColor *aColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextAddArc(context, 10, 10, 10, 0, 2 * M_PI, 0); //添加一个圆
//    CGContextAddArc(context, 10, height-10, 10, 0, 2 * M_PI, 0); //添加一个圆
//    CGContextAddArc(context, width-10, 10, 10, 0, 2 * M_PI, 0); //添加一个圆
//    CGContextAddArc(context, width-10, height-10, 10, 0, 2 * M_PI, 0); //添加一个圆
//    
//    CGContextStrokePath(context);
//}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */
- (void)change_angel:(NSString *)newValue
{
    //自己的代码实现
    _angel = [newValue intValue];
    NSLog(@"angel = %d",_angel);
}
- (void)change_enabled:(NSString *)newValue
{
    //自己的代码实现
    if (!newValue || [newValue isEqualToString:@""]) {
        self.userInteractionEnabled = YES;
    }else
        self.userInteractionEnabled = [newValue boolValue];
}
- (void)change_fontColor:(NSString *)newValue
{
    //自己的代码实现
    UIColor* color = [doUIModuleHelper GetColorFromString:newValue :[UIColor blackColor]] ;
    _color = color;
}

- (void)change_fontPath:(NSString *)newValue
{
    NSString * ttfPath = [doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :newValue ];
    NSData *dynamicFontData = [NSData dataWithContentsOfFile:ttfPath];
    if (!dynamicFontData)
    {
        return;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)dynamicFontData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(providerRef);
    if (! CTFontManagerRegisterGraphicsFont(fontRef, &error))
    {
        //注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    NSLog(@"fontName: %@, ",fontName);
    _fontName = fontName;
    UIFont *font = [UIFont fontWithName:fontName size: _fontSize ];
    CFRelease(fontRef);
    CFRelease(providerRef);
    
    _font = font;
}

- (void)change_fontSize:(NSString *)newValue
{
    _fontSize = [newValue intValue];
    
    if ( _fontName != NULL ){
        _font = [UIFont fontWithName:_fontName size:_fontSize ];
    }else{
        _font = [UIFont systemFontOfSize:_fontSize ];
    }
}

- (void)change_fontStyle:(NSString *)newValue
{
    //自己的代码实现
    _myFontStyle = [NSString stringWithFormat:@"%@",newValue];
    if (_text==nil || [_text isEqualToString:@""])
        return;
    
    float fontSize = _font.pointSize;
    if([newValue isEqualToString:@"normal"])
        _font = [UIFont systemFontOfSize:fontSize];
    else if([newValue isEqualToString:@"bold"])
    {
        _font = [UIFont boldSystemFontOfSize:fontSize];
    }
    else if([newValue isEqualToString:@"italic"])
    {
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(FONT_OBLIQUITY * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :fontSize ]. fontName matrix :matrix];
        _font  = [ UIFont fontWithDescriptor :desc size :fontSize];
    }
    else if([newValue isEqualToString:@"bold_italic"]){}
}
- (void)change_heights:(NSString *)newValue
{
    //自己的代码实现
    
    [self setTransform:CGAffineTransformIdentity];//回归原位置
    float w = self.frame.size.width;
    [self setFrame:CGRectMake( self.frame.origin.x, self.frame.origin.y, w, [newValue intValue] )];
    float h = self.frame.size.height;
    
    [[self viewWithTag:402] setFrame:CGRectMake(BODER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新左下角小圆点
    [[self viewWithTag:403] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:101] setFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER))]; //更新_image图像位置
}
- (void)change_maxLength:(NSString *)newValue
{
    //自己的代码实现
}
- (void)change_maxLines:(NSString *)newValue
{
    //自己的代码实现
}

- (void)change_image:(NSString *)newValue
{
//    NSString * path = [doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :newValue ];
//    _image = path;
    _image = newValue;
}

- (void)change_selected:(NSString *)newValue
{
    //自己的代码实现
    _selected = [newValue boolValue];
}

- (void)change_text:(NSString *)newValue
{
    //自己的代码实现
    _text = newValue;
    _image = @"";
}

- (void)change_widths:(NSString *)newValue
{
    //自己的代码实现
    
    [self setTransform:CGAffineTransformIdentity];//回归原先位置
    float h = self.frame.size.height;
    [self setFrame:CGRectMake( self.frame.origin.x, self.frame.origin.y, [newValue intValue], h)];
    float w = self.frame.size.width;
    [[self viewWithTag:403] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:404] setFrame:CGRectMake(w-BODER-DIAMETER, BODER, DIAMETER, DIAMETER)];//更新右上角小圆点
    [[self viewWithTag:101] setFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER))]; //更新_image图像位置
}

#pragma mark -
#pragma mark - 同步异步方法的实现
//同步
- (void)refreshSelf:(NSArray *)parms
{
//    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
//    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    
    [self setNeedsDisplay];
    
//    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    
}

#pragma mark - event
-(void)selectedClick:(M4411_SelfTextView_UIView *) _doSelfTextViewView
{
    doInvokeResult* _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touch":_invokeResult];
}

#pragma mark -私有方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(point.x/_model.XZoom) forKey:@"x"];
    [dict setObject:@(point.y/_model.YZoom) forKey:@"y"];
    doInvokeResult *invokeResult = [[doInvokeResult alloc]init];
    [invokeResult SetResultNode:dict];
    [_model.EventCenter FireEvent:@"touch" :invokeResult];
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (NSDictionary *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end
