//
//  JovisTopTabBar.h
//  JovisTopTabBarDemo
//
//  Created by Jovi on 15/11/14.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JovisTopTabBar;

@protocol JovisTopTabBarDelegate <NSObject>

@optional
- (BOOL)topTabBar:(JovisTopTabBar*)topTabBar willSelectTabIndex:(NSInteger)index;
- (void)topTabBar:(JovisTopTabBar*)topTabBar didSelectTabIndex:(NSInteger)index;

@end

@interface JovisTopTabBar : UIView

@property (strong, nonatomic) NSMutableArray<NSString*> *titleArray;
@property (strong, nonatomic) UIColor *titleColorForNormal;
@property (strong, nonatomic) UIColor *titleColorForSelected;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *indicatorLineColor;
@property (assign, nonatomic) CGFloat indicatorLineHeight;

@property (weak, nonatomic) id<JovisTopTabBarDelegate> delegate;

@property (assign, nonatomic) NSInteger defaultTabIndex;
@property (weak, nonatomic, readonly) UIButton *selectedTabButton;
@property (assign, nonatomic, readonly) NSInteger selectedTabIndex;
@property (weak, nonatomic, readonly) UIButton *prevSelectedTabButton;
@property (assign, nonatomic, readonly) NSInteger prevSelectedTabIndex;

@property (weak, nonatomic, readonly) UIView *tabsContainer;

@property (weak, nonatomic, readonly) UIView *indicatorLine;

@property (weak, nonatomic, readonly) CALayer *bottomLayer;

- (instancetype)initWithTitles:(NSArray*)titles;
- (void)initializeUI;
- (void)selectTabWithIndex:(NSInteger)index;

@end
