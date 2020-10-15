//
//  ViewController.h
//  Demo
//
//  Created by edz on 2020/10/15.
//  Copyright © 2020 WellsCai. All rights reserved.

#import "TestViewController.h"
#import "YRPopMenuView.h"
@interface TestViewController ()
@property(nonatomic,strong)NSArray      *arr;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = nil; [UIImage imageNamed:@"ic_filter_category_0"];
  
    self.arr = @[[YRPopMenuMode modeWithTitle:@"首页" image:image],
                 [YRPopMenuMode modeWithTitle:@"个人" image:image],
                 [YRPopMenuMode modeWithTitle:@"最新" image:image],
                 [YRPopMenuMode modeWithTitle:@"搜索页" image:image],
                 [YRPopMenuMode modeWithTitle:@"新闻页" image:image],
                 [YRPopMenuMode modeWithTitle:@"首页2" image:image],
                 [YRPopMenuMode modeWithTitle:@"个人2" image:image],
                 [YRPopMenuMode modeWithTitle:@"最新3" image:image],
                 [YRPopMenuMode modeWithTitle:@"搜索页3" image:image],
                 [YRPopMenuMode modeWithTitle:@"新闻页3" image:image]
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    
    // 创建
    
    YRPopMenuView *view = [YRPopMenuView menuWithModeArr:self.arr width:140 atPoint:point];

    // 自定义设置
//    view.menuColor = [UIColor whiteColor];
//    view.separatorColor = [UIColor whiteColor];
    view.maxDisplayCount = 5;
//    view.offset = 0;
//    view.textColor = [UIColor whiteColor];
//    view.textFont = [UIFont boldSystemFontOfSize:18];
//    view.menuCellHeight = 60;
//    view.dismissOnselected = YES;
//    view.dismissOnTouchOutside = YES;

    // 显示
    [view show];
    
    
}
- (IBAction)buttonItemClick:(UIBarButtonItem *)sender {
    YRPopMenuView *view = [YRPopMenuView menuWithModeArr:self.arr width:140 relyonView:sender];
    [view show];

    
}
- (IBAction)button1Click:(UIButton *)sender {
    YRPopMenuView *view = [YRPopMenuView menuWithModeArr:self.arr width:140 relyonView:sender];
    [view show];
}
- (IBAction)button2Click:(UIButton *)sender {
    YRPopMenuView *view = [YRPopMenuView menuWithModeArr:self.arr width:140 relyonView:sender];
    [view show];
}
- (IBAction)button3Click:(UIButton *)sender {
    YRPopMenuView *view = [YRPopMenuView menuWithModeArr:self.arr width:140 relyonView:sender];
    [view show];
}

 

@end
