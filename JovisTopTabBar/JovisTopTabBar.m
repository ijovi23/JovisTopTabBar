//
//  JovisTopTabBar.m
//  JovisTopTabBarDemo
//
//  Created by Jovi on 15/11/14.
//  Copyright © 2015年 Jovistudio. All rights reserved.
//

#import "JovisTopTabBar.h"

#define DefaultTitleColorForNormal      [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
#define DefaultTitleColorForSelected    [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
#define DefaultTitleFont                [UIFont systemFontOfSize:13]
#define DefaultIndicatorLineColor       [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
#define DefaultIndicatorLineHeight      2.0

@implementation JovisTopTabBar

- (instancetype)initWithTitles:(NSArray*)titles{
    self = [super init];
    if (self) {
        self.titleArray = [NSMutableArray arrayWithArray:titles];
    }
    return self;
}

- (void)initializeUI{
    
    if (!self.titleColorForNormal) {
        self.titleColorForNormal = DefaultTitleColorForNormal;
    }
    if (!self.titleColorForSelected) {
        self.titleColorForSelected = DefaultTitleColorForSelected;
    }
    if (!self.titleFont) {
        self.titleFont = DefaultTitleFont;
    }
    if (!self.indicatorLineColor) {
        self.indicatorLineColor = DefaultIndicatorLineColor;
    }
    if (self.indicatorLineHeight < 0) {
        self.indicatorLineHeight = DefaultIndicatorLineHeight;
    }
    
    if (!_tabsContainer) {
        UIView *tabsContainer = [[UIView alloc]init];
        [self addSubview:tabsContainer];
        _tabsContainer = tabsContainer;
    }
    [_tabsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        NSString *title = _titleArray[i];
        UIButton *tabButton = [[UIButton alloc]init];
        [tabButton setTag:i];
        [tabButton.titleLabel setFont:_titleFont];
        [tabButton setTitleColor:_titleColorForNormal forState:UIControlStateNormal];
        [tabButton setTitle:title forState:UIControlStateNormal];
        [tabButton addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabsContainer addSubview:tabButton];
        
    }
    
    if (!_indicatorLine) {
        UIView *indicatorLine = [[UIView alloc]init];
        [self addSubview:indicatorLine];
        _indicatorLine = indicatorLine;
    }
    [_indicatorLine setBackgroundColor:_indicatorLineColor];
    
    if (!_bottomLayer) {
        CALayer *bottomLayer = [CALayer layer];
        [self.layer addSublayer:bottomLayer];
        _bottomLayer = bottomLayer;
    }
    [_bottomLayer setBackgroundColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1].CGColor];
    
    _selectedTabIndex = _defaultTabIndex;
    _selectedTabButton = [_tabsContainer.subviews objectAtIndex:_selectedTabIndex];
    [self layoutUI];
    [self _changeTab:_selectedTabIndex];
}

- (void)tabPressed:(UIButton*)sender{
    if (_selectedTabIndex == sender.tag) {
        return;
    }
    [self _changeTab:sender.tag];
}

- (void)_changeTab:(NSInteger)targetIndex{
    if (_delegate && [_delegate respondsToSelector:@selector(topTabBar:willSelectTabIndex:)]) {
        if ([_delegate topTabBar:self willSelectTabIndex:targetIndex] == NO) {
            return;
        }
    }
    
    _prevSelectedTabIndex = _selectedTabIndex;
    _prevSelectedTabButton = _selectedTabButton;
    _selectedTabIndex = targetIndex;
    _selectedTabButton = [_tabsContainer.subviews objectAtIndex:targetIndex];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(topTabBar:didSelectTabIndex:)]) {
        [_delegate topTabBar:self didSelectTabIndex:_selectedTabIndex];
    }
    
    [self _animateForChange:_selectedTabIndex];
}

- (void)_animateForChange:(NSInteger)targetIndex{
    CGRect oldFrame = _indicatorLine.frame;
    CGRect newFrame = oldFrame;
    newFrame.origin.x = _selectedTabButton.frame.origin.x;
    newFrame.size.width = _selectedTabButton.frame.size.width;
    CGRect tranFrame;
    if (newFrame.origin.x > oldFrame.origin.x) {
        tranFrame = oldFrame;
        tranFrame.size.width = CGRectGetMaxX(newFrame) - CGRectGetMinX(oldFrame);
    }else{
        tranFrame = newFrame;
        tranFrame.size.width = CGRectGetMaxX(oldFrame) - CGRectGetMinX(newFrame);
    }
    
    [UIView animateWithDuration:0.10 animations:^{
        [_indicatorLine setFrame:tranFrame];
        [_prevSelectedTabButton setTitleColor:_titleColorForNormal forState:UIControlStateNormal];
        [_selectedTabButton setTitleColor:_titleColorForSelected forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.10 animations:^{
            [_indicatorLine setFrame:newFrame];
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

- (void)selectTabWithIndex:(NSInteger)index{
    if (_selectedTabIndex == index) {
        return;
    }
    if (index < 0 || index >= _titleArray.count) {
        return;
    }
    [self _changeTab:index];
    
}

- (void)layoutUI{
    /* !! self.frame is NOT allowed to be set here !! */
    [_tabsContainer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if (_tabsContainer.subviews.count > 0) {
        CGFloat btnWidth = _tabsContainer.frame.size.width / _tabsContainer.subviews.count;
        for (NSInteger i = 0; i < _tabsContainer.subviews.count; i++) {
            UIButton *btn = [_tabsContainer.subviews objectAtIndex:i];
            [btn setFrame:CGRectMake(btnWidth * i, 0, btnWidth, _tabsContainer.frame.size.height)];
        }
        
        [_indicatorLine setFrame:CGRectMake(_selectedTabButton.frame.origin.x, _selectedTabButton.frame.size.height - _indicatorLineHeight, _selectedTabButton.frame.size.width, _indicatorLineHeight)];
    }
    [_bottomLayer setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutUI];
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    if (_tabsContainer) {
        for (UIButton *tab in _tabsContainer.subviews) {
            [tab.titleLabel setFont:_titleFont];
        }
    }
}

- (void)setIndicatorLineHeight:(CGFloat)indicatorLineHeight{
    _indicatorLineHeight = indicatorLineHeight;
    if (_indicatorLine) {
        CGRect indFrame = _indicatorLine.frame;
        indFrame.origin.y = _tabsContainer.frame.size.height - _indicatorLineHeight;
        indFrame.size.height = _indicatorLineHeight;
        [_indicatorLine setFrame:indFrame];
    }
}

- (void)setIndicatorLineColor:(UIColor *)indicatorLineColor{
    _indicatorLineColor = indicatorLineColor;
    if (_indicatorLine) {
        [_indicatorLine setBackgroundColor:_indicatorLineColor];
    }
}

@end
