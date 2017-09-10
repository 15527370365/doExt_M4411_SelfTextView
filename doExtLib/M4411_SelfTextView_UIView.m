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
#define DIAMETER 30 //直径
#define FONT_OBLIQUITY 15.0
#define DEBUG 0


@implementation M4411_SelfTextView_UIView
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象

- (void) LoadView: (doUIModule *) _doUIModule
{
    
    _model = (typeof(_model)) _doUIModule;
    
    _text = [(doUIModule *)_model GetProperty:@"text"].DefaultValue;
    _fontSize = 16;
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
    if (!(self.transform.a==1 && self.transform.b==0 && self.transform.c==0 && self.transform.d==1 && self.transform.tx==0 && self.transform.ty==0)){
        _trans = self.transform;
        [self setTransform:CGAffineTransformIdentity];//回归原位置
    }
    _width = self.frame.size.width;
    _height = self.frame.size.height;
    if (_first){
        
        //单击事件
        UITapGestureRecognizer *singleTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGestureRecognizer];
        
        //双击事件
        UITapGestureRecognizer *doubleTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGestureRecognizer];
        
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        
        //拖动控件
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        
        //图片
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, _width - (BODER*2+DIAMETER), _height - (BODER*2+DIAMETER))];
        image.tag = 101;
        image.hidden = true;
        [self addSubview:image];
        
        //文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, _width - (BODER*2+DIAMETER), _height - (BODER*2+DIAMETER))];
        label.tag = 102;
        label.hidden = true;
        [self addSubview:label];
        
        //左上角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(BODER, BODER, DIAMETER, DIAMETER)];
        image.tag = 401;
        image.hidden = true;
        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/1.png" ]];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:@"delete"];
        }
        singleTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDeleteTap)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [image addGestureRecognizer:singleTapGestureRecognizer];
        [image setUserInteractionEnabled:YES];
        [self addSubview:image];
        
        //左下角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(BODER, _height-BODER-DIAMETER, DIAMETER, DIAMETER)];
        image.tag = 402;
        image.hidden = true;
        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/2.png" ]];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:@"transform"];
        }
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTransformPan:)];
        [image addGestureRecognizer:panGestureRecognizer];
        [image setUserInteractionEnabled:YES];
        [self addSubview:image];
        
        //右下角1
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(_width-BODER-DIAMETER, _height-BODER-DIAMETER, DIAMETER, DIAMETER)];
        image.tag = 403;
        image.hidden = true;
        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/3.png" ]];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:@"cross_move"];
        }
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCrossMovePan:)];
        [image addGestureRecognizer:panGestureRecognizer];
        [image setUserInteractionEnabled:YES];
        [self addSubview:image];
        
        //右下角2
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(_width-BODER-DIAMETER, _height-BODER-DIAMETER, DIAMETER, DIAMETER)];
        image.tag = 405;
        image.hidden = true;
        
        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/4.png" ]];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:@"move"];
        }
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovePan:)];
        [image addGestureRecognizer:panGestureRecognizer];
        [image setUserInteractionEnabled:YES];
        [self addSubview:image];
        
        
        //右上角
        image  = [[UIImageView alloc] initWithFrame:CGRectMake(_width-BODER-DIAMETER, BODER, DIAMETER, DIAMETER)];
        image.tag = 404;
        image.hidden = true;
        
        image.image = [UIImage imageWithContentsOfFile:[doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :@"source://image/5.png" ]];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:@"5"];
        }
        singleTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTopTap)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [image addGestureRecognizer:singleTapGestureRecognizer];
        [image setUserInteractionEnabled:YES];
        [self addSubview:image];
        _first = NO;
        _rate = _width/_height;
        _trans = self.transform;
    }
    
    //CGContextRef context=UIGraphicsGetCurrentContext();//设置一个空白view，准备画画
    
    
    for (int i=401; i<=405; i++) {
        [self viewWithTag:i].hidden = !_selected;
    }
    for (int i=101; i<=102; i++) {
        [self viewWithTag:i].hidden = true;
    }
    int select_tag = 403;
    if( _image!= NULL && ![_image isEqualToString:@""] )
    {
        //显示图片
        UIImageView *image = [self viewWithTag:101];
        image.image = [UIImage imageWithContentsOfFile:_image];
        if (DEBUG == 1){
            image.image = [UIImage imageNamed:_image];
        }
        image.hidden = false;
    }else{
        NSLog(@"字体%@", _font.fontName);
        //        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        //        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        //        NSDictionary* attribute = @{
        //                                    NSForegroundColorAttributeName: _color,//设置文字颜色
        //                                    NSFontAttributeName:_font,//设置文字的字体
        //                                    NSParagraphStyleAttributeName:paragraphStyle,//设置文字的样式
        //                                    };
        select_tag = 405;
        CGSize textSize = [_text boundingRectWithSize:CGSizeMake(self.frame.size.width - (BODER*2+DIAMETER), CGFLOAT_MAX)
                                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:_font}
                                              context:nil].size;
        
        _height = textSize.height+BODER*2+DIAMETER;
        [self change_heights:[NSString stringWithFormat:@"%f",_height]];
        //在内部矩形显示文字
        UILabel *label = [self viewWithTag:102];
        label.text = _text;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = _font;
        label.textColor = _color;
        label.frame = CGRectMake( BODER+DIAMETER/2, BODER+DIAMETER/2, _width - (BODER*2+DIAMETER), _height - (BODER*2+DIAMETER));
        label.hidden = false;
    }
    //隐藏其中一个右下角图标
    [self viewWithTag:select_tag].hidden = true;
    
    
    // 选中时，显示提示文字
    if( _selected ) {
        
        NSString * indicator = @"双击编辑";
        
        //计算文字的宽度和高度：支持多行显示
        
        UIFont  * indiFont = [UIFont systemFontOfSize:14.0];
        
        CGSize sizeText = [indicator boundingRectWithSize:self.bounds.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{
                                                            NSFontAttributeName:indiFont,//文字的字体
                                                            }
                                                  context:nil].size;
        
        int beginx = (_width-sizeText.width)/2;
        if( beginx<0 )
            beginx = 0;
        CGRect indiDispRect = CGRectMake(beginx, 0, sizeText.width, sizeText.height );
        [indicator drawInRect:indiDispRect withAttributes:@{
                                                            NSForegroundColorAttributeName: _color,//设置文字颜色
                                                            NSFontAttributeName:indiFont,//设置文字的字体
                                                            NSParagraphStyleAttributeName:[[NSParagraphStyle defaultParagraphStyle] mutableCopy],//设置文字的样式
                                                            }];
        
        
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
        CGContextAddLineToPoint(context, BODER+DIAMETER/2, _height - (BODER+DIAMETER/2));
        //设置下一个坐标点：右下角
        CGContextAddLineToPoint(context, _width - (BODER+DIAMETER/2), _height - (BODER+DIAMETER/2));
        //设置下一个坐标点：右上角
        CGContextAddLineToPoint(context, _width - (BODER+DIAMETER/2), BODER+DIAMETER/2);
        //设置下一个坐标点：左上角
        CGContextAddLineToPoint(context, BODER+DIAMETER/2, BODER+DIAMETER/2);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
        
    }
    self.transform = _trans;
    if (_angel != 0)
    {
        [self setTransform:CGAffineTransformMakeRotation( _angel * M_PI/180.0) ];
    }
    
}




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
    [self setNeedsDisplay];
}
- (void)change_enabled:(NSString *)newValue
{
    //自己的代码实现
    if (!newValue || [newValue isEqualToString:@""]) {
        self.userInteractionEnabled = YES;
    }else
        self.userInteractionEnabled = [newValue boolValue];
    [self setNeedsDisplay];
}
- (void)change_fontColor:(NSString *)newValue
{
    //自己的代码实现
    UIColor* color = [doUIModuleHelper GetColorFromString:newValue :[UIColor blackColor]] ;
    _color = color;
    [self setNeedsDisplay];
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
    [self setNeedsDisplay];
}

- (void)change_fontSize:(NSString *)newValue
{
    _fontSize = [newValue intValue];
    
    if ( _fontName != NULL ){
        _font = [UIFont fontWithName:_fontName size:_fontSize ];
    }else{
        _font = [UIFont systemFontOfSize:_fontSize ];
    }
    [self setNeedsDisplay];
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
    [self setNeedsDisplay];
}
- (void)change_heights:(NSString *)newValue
{
    //自己的代码实现
    if (!(self.transform.a==1 && self.transform.b==0 && self.transform.c==0 && self.transform.d==1 && self.transform.tx==0 && self.transform.ty==0)){
        _trans = self.transform;
        [self setTransform:CGAffineTransformIdentity];//回归原位置
    }
    float w = self.frame.size.width;
    [self setFrame:CGRectMake( self.frame.origin.x, self.frame.origin.y, w, [newValue intValue] )];
    float h = self.frame.size.height;
    
    [[self viewWithTag:402] setFrame:CGRectMake(BODER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新左下角小圆点
    [[self viewWithTag:403] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:405] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:101] setFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER))]; //更新_image图像位置
    [self setNeedsDisplay];
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
    if (DEBUG==1){
        _image = newValue;
    }else{
        NSString * path = [doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :newValue ];
        _image = path;
    }
    [self setNeedsDisplay];
}

- (void)change_selected:(NSString *)newValue
{
    //自己的代码实现
    _selected = [newValue boolValue];
    [self setNeedsDisplay];
}

- (void)change_text:(NSString *)newValue
{
    //自己的代码实现
    _text = newValue;
    _image = @"";
    _selected = NO;
    [self setNeedsDisplay];
}

- (void)change_widths:(NSString *)newValue
{
    //自己的代码实现
    if (!(self.transform.a==1 && self.transform.b==0 && self.transform.c==0 && self.transform.d==1 && self.transform.tx==0 && self.transform.ty==0)){
        _trans = self.transform;
        [self setTransform:CGAffineTransformIdentity];//回归原位置
    }
    float h = self.frame.size.height;
    [self setFrame:CGRectMake( self.frame.origin.x, self.frame.origin.y, [newValue intValue], h)];
    float w = self.frame.size.width;
    [[self viewWithTag:403] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:405] setFrame:CGRectMake(w-BODER-DIAMETER, h-BODER-DIAMETER, DIAMETER, DIAMETER)];//更新右下角小圆点
    [[self viewWithTag:404] setFrame:CGRectMake(w-BODER-DIAMETER, BODER, DIAMETER, DIAMETER)];//更新右上角小圆点
    [[self viewWithTag:101] setFrame:CGRectMake(BODER+DIAMETER/2, BODER+DIAMETER/2, w - (BODER*2+DIAMETER), h - (BODER*2+DIAMETER))]; //更新_image图像位置
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - 同步异步方法的实现
//同步
//- (void)refreshSelf:(NSArray *)parms
//{
//    //    NSDictionary *_dictParas = [parms objectAtIndex:0];
//    //参数字典_dictParas
//    //    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
//    //自己的代码实现
//    
//    [self setNeedsDisplay];
//    [self layoutIfNeeded];
//    
//    //    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
//    //_invokeResult设置返回值
//    
//}

#pragma mark - event
-(void)selectedClick:(M4411_SelfTextView_UIView *) _doSelfTextViewView
{
    doInvokeResult* _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touch":_invokeResult];
}

- (void)handleMovePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint point1 = [recognizer translationInView:self];
    CGPoint currentPoint = CGPointMake(recognizer.view.center.x + point1.x, recognizer.view.center.y + point1.y);//当前手指的坐标
    CGPoint previousPoint = [self viewWithTag:403].center;//上一个坐标
    
//    float distance = sqrt(pow((currentPoint.x - previousPoint.x), 2) + pow((currentPoint.y - previousPoint.y), 2));
//    float height = currentPoint.y - previousPoint.y;
    
//    float change =sqrt(pow(distance,2)-pow(height,2));
    float change = currentPoint.x - previousPoint.x;
//    if (point1.x < 0){
//        change = -change;
//    }
    [self change_widths:[NSString stringWithFormat:@"%f",change+_width]];
    [self change_heights:[NSString stringWithFormat:@"%f",(change+_width)/_rate]];
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)handleTransformPan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint point1 = [recognizer translationInView:self];
    CGPoint currentPoint = CGPointMake(recognizer.view.center.x + point1.x, recognizer.view.center.y + point1.y);//当前手指的坐标
    CGPoint center = [self.superview convertPoint:self.center toView:self];
    CGPoint previousPoint = [self viewWithTag:402].center;//上一个坐标
    /**
     求得每次手指移动变化的角度
     atan2f 是求反正切函数
     */
    CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x) - atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
    float a = angle * 180.0/M_PI;
    //[self setTransform:CGAffineTransformIdentity];
    self.transform = CGAffineTransformRotate(self.transform,a*M_PI/180.0);
    _trans = self.transform;
    _angel = 0;
    //    [recognizer setTranslation:CGPointZero inView:self];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)handleCrossMovePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint point1 = [recognizer translationInView:self];
    CGPoint currentPoint = CGPointMake(recognizer.view.center.x + point1.x, recognizer.view.center.y + point1.y);//当前手指的坐标
    CGPoint previousPoint = [self viewWithTag:403].center;//上一个坐标
    
    float distance = sqrt(pow((currentPoint.x - previousPoint.x), 2) + pow((currentPoint.y - previousPoint.y), 2));
    float height = currentPoint.y - previousPoint.y;
    
    float change =sqrt(pow(distance,2)-pow(height,2));
    if (point1.x < 0){
        change = -change;
    }
    [self change_widths:[NSString stringWithFormat:@"%f",change+_width]];
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    if (_selected){
        //获取手势的位置
        CGPoint position =[recognizer translationInView:self];
        
        //通过stransform 进行平移交换
        self.transform = CGAffineTransformTranslate(self.transform, position.x, position.y);
        
        _trans = self.transform;
        
        //将增量置为零
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void)handleTopTap
{
    [self.superview bringSubviewToFront:self];
}
- (void)handleDeleteTap
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    doInvokeResult *invokeResult = [[doInvokeResult alloc]init];
    [invokeResult SetResultNode:dict];
    [_model.EventCenter FireEvent:@"delete" :invokeResult];
}
- (void)handleSingleTap
{
    ((UIScrollView *)self.superview).scrollEnabled = _selected;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    doInvokeResult *invokeResult = [[doInvokeResult alloc]init];
    [invokeResult SetResultNode:dict];
    [_model.EventCenter FireEvent:@"touch" :invokeResult];
}
- (void)handleDoubleTap
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    doInvokeResult *invokeResult = [[doInvokeResult alloc]init];
    [invokeResult SetResultNode:dict];
    [_model.EventCenter FireEvent:@"doubleClick" :invokeResult];
}

#pragma mark -私有方法
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@(point.x/_model.XZoom) forKey:@"x"];
//    [dict setObject:@(point.y/_model.YZoom) forKey:@"y"];
//    doInvokeResult *invokeResult = [[doInvokeResult alloc]init];
//    [invokeResult SetResultNode:dict];
//    [_model.EventCenter FireEvent:@"touch" :invokeResult];
//}

//- (float) heightForString:(NSString *)value andWidth:(float)width{
//    //获取当前文本的属性
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
//    NSRange range = NSMakeRange(0, attrStr.length);
//    // 获取该段attributedString的属性字典
//    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
//    // 计算文本的大小
//    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - _fontSize, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
//                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
//                                        attributes:dic        // 文字的属性
//                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
//    return sizeToFit.height + _fontSize;
//}


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
