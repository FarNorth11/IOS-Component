//
//  ViewController.m
//  SearchBarDemo
//
//  Created by Ben on 2018/8/16.
//  Copyright © 2018年 com.het.HETStaticFrameWork. All rights reserved.
//

#import "ViewController.h"
#import "searchBarDownView.h"
#import "SearchFoodModel.h"

@interface ViewController ()<searchBarDownViewDelegate>{
    searchBarDownView *searchBar;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    searchBar = [[searchBarDownView alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 60)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 点击下拉列表
 */
-(void)tableViewDidSelectRow:(NSInteger)row{
    
}
/*
 搜索框里的内容改变的时候
 */
-(void)searchTextDidChange:(NSString *)searchText{
    NSMutableArray *filterData = [[NSMutableArray alloc]init];
    SearchFoodModel *m1 = [[SearchFoodModel alloc]init];
    m1.ingredientName = @"aaa";
    m1.categoryName = @"bbb";
    [filterData addObject:m1];
    SearchFoodModel *m2 = [[SearchFoodModel alloc]init];
    m2.ingredientName = @"ccc";
    m2.categoryName = @"ddd";
    [filterData addObject:m2];
    SearchFoodModel *m3 = [[SearchFoodModel alloc]init];
    m3.ingredientName = @"fff";
    m3.categoryName = @"ggg";
    [filterData addObject:m3];
    [searchBar refreshDataSource:filterData];
}
@end
