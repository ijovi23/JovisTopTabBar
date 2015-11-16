//
//  ViewController.m
//  JovisTopTabBarDemo
//
//  Created by Jovi on 15/11/14.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import "ViewController.h"
#import "JovisTopTabBar.h"

@interface ViewController () <JovisTopTabBarDelegate>
@property (strong, nonatomic) JovisTopTabBar *tabBar;
@end

@implementation ViewController{
    UILabel *_lab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizesSubviews = NO;
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    UIButton *bbb = [UIButton buttonWithType:UIButtonTypeSystem];
    [bbb setFrame:CGRectMake(0, 50, 100, 30)];
    [bbb setTitle:@"test" forState:UIControlStateNormal];
    
    [bbb addTarget:self action:@selector(createTabbar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bbb];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setBounds:CGRectMake(0, 0, 180, 30)];
    [lab setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    [self.view addSubview:lab];
    _lab = lab;
}

- (void)createTabbar:(id)sender{
    if (_tabBar) {
        [_tabBar removeFromSuperview];
        _tabBar = nil;
    }
    _tabBar = [[JovisTopTabBar alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    [self.view addSubview:_tabBar];
    [_tabBar setBackgroundColor:[UIColor whiteColor]];
//    [_tabBar setFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    [_tabBar setTitleArray:[NSMutableArray arrayWithArray:@[@"首页",@"搜索",@"音乐",@"电影",@"个人"]]];
    [_tabBar setIndicatorLineHeight:1.0];
    [_tabBar setTitleFont:[UIFont systemFontOfSize:15]];
    UIColor *tc = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1];
    [_tabBar setTitleColorForSelected:tc];
    [_tabBar setIndicatorLineColor:tc];
    [_tabBar setDelegate:self];
    [_tabBar initializeUI];
    
    [_tabBar selectTabWithIndex:0];
}

- (void)topTabBar:(JovisTopTabBar *)topTabBar didSelectTabIndex:(NSInteger)index{
    NSLog(@"select: %ld", index);
    __weak UIButton *btn = topTabBar.tabsContainer.subviews[index];
    [_lab setText:[NSString stringWithFormat:@"select: %ld %@", index, btn.titleLabel.text]];
}

@end
