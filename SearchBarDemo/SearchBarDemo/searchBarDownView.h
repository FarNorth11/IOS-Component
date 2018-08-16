//
//  searchBarDownView.h
//  wisdom_school_ios
//
//  Created by Ben on 2018/5/20.
//  Copyright © 2018年 het. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchBarDownViewDelegate <NSObject>
/*
 点击 action (搜索/添加)
 */
-(void)addFoodToView:(NSString *)textStr;
/*
 点击下拉列表
 */
-(void)tableViewDidSelectRow:(NSInteger)row;
/*
 搜索框里的内容改变的时候
 */
-(void)searchTextDidChange:(NSString *)searchText;

@end

@interface searchBarDownView : UIView

/**
 *  frame
 */
//@property (nonatomic,assign) CGRect Frame;

@property (nonatomic,weak) id<searchBarDownViewDelegate> delegate;


-(void)refreshDataSource:(NSMutableArray *)listData;
//隐藏下拉框
-(void)hiden;
//清空输入数据
-(void)emptySearchText;
@end
