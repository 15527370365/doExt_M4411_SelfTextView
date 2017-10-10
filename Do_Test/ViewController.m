//
//  ViewController.m
//  Do_Test
//
//  Created by linliyuan on 15/4/27.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "ViewController.h"
#import "doPage.h"
#import "doService.h"
#import "doModuleFactory.h"
#import "M4411_SelfTextView_UIModel.h"
#import "M4411_SelfTextView_UIView.h"


@interface ViewController ()
{
@private
    NSString *Type;
    doModule* model;
}
@end
@implementation CallBackEvnet

-(void)eventCallBack:(NSString *)_data
{
    NSLog(@"异步方法回调数据:%@",_data);
}

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitInstance];
    [self ConfigUI];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void) InitInstance
{
    NSString *testPath = [[NSBundle mainBundle] pathForResource:@"do_Test" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:testPath];
    NSMutableDictionary *_testDics = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    Type = [_testDics valueForKey:@"Type"];
    //在下面构造model
    model = [[M4411_SelfTextView_UIModel alloc]init];
    
    [doServiceContainer Instance].SingletonModuleFactory =  [[doModuleFactory alloc]init:model];
    
    //如果是UI类型，还需要构造view
    M4411_SelfTextView_UIView* view = [[M4411_SelfTextView_UIView alloc]init];
    view.tag = 1001;
    view.frame = CGRectMake(100, 100, 200, 200);
    view.backgroundColor = [UIColor redColor];
    [view LoadView:model];
    //view.image = [UIImage imageNamed:@"test"];
    UIScrollView *scoll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 600, 400)];
    scoll.tag = 1002;
    scoll.backgroundColor = [UIColor blueColor];
    scoll.contentSize = CGSizeMake(0, 400);
    scoll.scrollEnabled = NO;
    [self.view addSubview:scoll];
    [scoll addSubview:view];
    [view change_text:@"kkjgjhgjkgj"];
    [view change_angel:@"45"];
//    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRectMake(50, 50, 200, 200))];
//    image.image = [UIImage imageNamed:@"test"];
//    [self.view addSubview:image];
    
    
    //[view LoadView:model];
    
}
- (void)ConfigUI {
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    //在对应的测试按钮添加自己的测试代码, 如果6个测试按钮不够，可以自己添加
    
    if([Type isEqualToString:@"UI"]){
        //和SM，MM不一样，UI类型还得添加自己的View，所以测试按钮都在底部
        CGFloat height = h/6;
        CGFloat width = (w - 35)/6;
        for(int i = 0;i<6;i++){
            UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
            test.frame = CGRectMake(5*(i+1)+width*i, h-h/6, width, height);
            NSString* title = [NSString stringWithFormat:@"Test%d",i ];
            [test setTitle:title forState:UIControlStateNormal];
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"test%d:",i]);
            [test addTarget:self action:customSelector forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:test];
        }
        //addsubview 自定义的UI
        
    }else{
        CGFloat height = (h-140)/6;
        CGFloat width = w - 60;
        for(int i = 0;i<6;i++){
            UIButton *test = [UIButton buttonWithType:UIButtonTypeCustom];
            test.frame = CGRectMake(30, 20*(i+1)+height*i, width, height);
            NSString* title = [NSString stringWithFormat:@"Test%d",i ];
            [test setTitle:title forState:UIControlStateNormal];
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"test%d:",i]);
            [test addTarget:self action:customSelector forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:test];
        }
    }
}

- (void)test0:(UIButton *)sender
{
    NSLog(@"改变宽");
    M4411_SelfTextView_UIView *view = [self.view viewWithTag:1001];
    
    //[view change_fontSize:@"14"];
    [view change_widths:@"200"];
}
- (void)test1:(UIButton *)sender
{
    NSLog(@"显示文字");
    M4411_SelfTextView_UIView *view = [self.view viewWithTag:1001];
    [view change_text:@"中华人民共和国中南财经政法大学好好学习天天向上呼吸系统abc我们的太阳升起来"];
    

    //执行同步方法
    //NSMutableDictionary* node = [[NSMutableDictionary alloc]init];
    //[node setObject:参数值 forKey:参数名];
    //[[doService Instance] SyncMethod:model :同步方法名 :node];
    
}
- (void)test2:(UIButton *)sender
{
    NSLog(@"添加纸");
    UIScrollView *scoll = [self.view viewWithTag:1002];
    [scoll setFrame:CGRectMake(scoll.frame.origin.x, scoll.frame.origin.y, scoll.frame.size.width, scoll.frame.size.width+200)];
    [scoll setNeedsDisplay];
//    scoll.scrollEnabled = NO;
    //执行异步方法
    //NSMutableDictionary* node = [[NSMutableDictionary alloc]init];
    //[node setObject:参数值 forKey:参数名];
    //CallBackEvnet* event = [[CallBackEvnet alloc]init];//回调类
    //[[doService Instance] AsyncMethod:model :异步步方法名 :node:event];

}
- (void)test3:(UIButton *)sender
{
    NSLog(@"选中");
    M4411_SelfTextView_UIView *view = [self.view viewWithTag:1001];
    [view change_selected:@"YES"];
    
}
- (void)test4:(UIButton *)sender
{
    NSLog(@"设置图片");
    M4411_SelfTextView_UIView *view = [self.view viewWithTag:1001];
    [view change_image:@"test"];
    
}
- (void)test5:(UIButton *)sender
{
    NSLog(@"取消选择");
    M4411_SelfTextView_UIView *view = [self.view viewWithTag:1001];
    [view change_selected:@"NO"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
