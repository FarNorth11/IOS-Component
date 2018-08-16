//
//  searchBarDownView.m
//  wisdom_school_ios
//
//  Created by Ben on 2018/5/20.
//  Copyright © 2018年 het. All rights reserved.
//

#import "searchBarDownView.h"
#import "SearchFoodModel.h"

@interface searchBarDownView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    BOOL isPopKeyboad;
    BOOL isSelectListPopkeyboard; //是否点击了(键盘弹起状态下的下拉搜索列表)
}

@property(nonatomic,strong)UITextField *searchBar;
@property(nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;//数据
@property (nonatomic,assign) float x;//自身的x坐标
@property (nonatomic,assign) float y;//自身的y坐标
@property (nonatomic,assign) float width;//宽度
@property (nonatomic,assign) float hight;//高

@end


@implementation searchBarDownView
//获取颜色
- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMaxY(self.searchBar.frame) + 2, CGRectGetWidth(self.searchBar.frame), 0)];
        _tableView.layer.borderColor = [self colorFromHexRGB:@"efefef"].CGColor;
        _tableView.layer.borderWidth = 1.;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isSelectListPopkeyboard = NO;
        isPopKeyboad = NO;
        [self layoutUI];
    }
    return self;
}

-(void)layoutUI{
    self.backgroundColor = [self colorFromHexRGB:@"efefef"];
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
//    _searchBar = [[YLSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-70, self.frame.size.height)];
//    [self addSubview:_searchBar];
//    __typeof (self)weakSelf = self;
//    _searchBar.backgroundColor = [UIColor blueColor];
//    self.searchBar.textChangeBlok = ^(NSString *str) {
//
//        [weakSelf textDidChange:str];
//    };
    
    
    UIView *bgSearchView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, self.frame.size.width-80, self.frame.size.height-30)];
    bgSearchView.backgroundColor = [UIColor whiteColor];
    //圆角弧度
    bgSearchView.layer.cornerRadius = CGRectGetHeight(bgSearchView.frame) / 5;
    bgSearchView.layer.masksToBounds = YES;//图片圆角阴影无效
    //搜索框的颜色和宽度
    bgSearchView.layer.borderWidth = 1.;
    bgSearchView.layer.borderColor = [UIColor grayColor].CGColor;
    [self addSubview:bgSearchView];
    
    
     _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, bgSearchView.frame.size.width-20, bgSearchView.frame.size.height-20)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入关键字";
    [bgSearchView addSubview:_searchBar];
    
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+CGRectGetMaxX(bgSearchView.frame), 20, 55, self.frame.size.height-30)];
    _addBtn.backgroundColor = [UIColor whiteColor];
    [_addBtn.layer setMasksToBounds:YES];
    [_addBtn.layer setCornerRadius:8.0]; //设置矩圆角半径
    [_addBtn.layer setBorderWidth:1.0];   //边框宽度
    [_addBtn.layer setBorderColor:[UIColor grayColor].CGColor];//边框颜色
    [_addBtn setTitle:@"添加" forState: UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addFoodToView) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_addBtn];
    
    [self.superview addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewEditChanged:)
                                                 name:UITextFieldTextDidChangeNotification object:nil];
    
    
  
    
}

-(void)emptySearchText{
    _searchBar.text = @"";
}

-(void)addFoodToView{
    
    if ([self.delegate respondsToSelector:@selector(addFoodToView:)]) {
        [self.delegate addFoodToView:_searchBar.text];
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.superview addSubview:self.tableView];
}
#pragma mark --UITextFieldDelegate
- (void)textViewEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if (!position) {
//        if (textField.text.length > deviceNameLeght) {
//            textField.text = [textField.text substringToIndex:deviceNameLeght];
//        }
//    }else{
//        if (textField.text.length > deviceNameLeght) {
//            textField.text = [textField.text substringToIndex:deviceNameLeght];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(searchTextDidChange:)]) {
        [self.delegate searchTextDidChange:textField.text];
    }
    [self.superview bringSubviewToFront: self];
    [self.superview bringSubviewToFront: self.tableView];
    
    if (textField.text.length == 0) {
        [textField resignFirstResponder];
    }
    

    if (isPopKeyboad) {
        float heightX =  self.data.count * 40;
        self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMinY(self.frame) - 2 -heightX, CGRectGetWidth(self.searchBar.frame), self.data.count * 40);
    }else{
       self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMaxY(self.frame) + 2, CGRectGetWidth(self.searchBar.frame), self.data.count * 40);
    }
    
    
    
//    //动态计算tableView高度
//    if (self.data.count > 0 && self.data.count < 8) {
//
//        self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMaxY(self.searchBar.frame) + 2, CGRectGetWidth(self.searchBar.frame), self.data.count * 40);
//
//
////        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, CGRectGetHeight(self.tableView.frame)+ 30);
//
//    }
//    if (self.data.count > 8) {
//
//        self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMaxY(self.searchBar.frame) + 2, CGRectGetWidth(self.searchBar.frame), 240);
////        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, 240 + self.hight);

    
}

-(void)tapRecognized:(UITapGestureRecognizer *)tap{
    
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        isSelectListPopkeyboard = YES;
        
    }else{
        isSelectListPopkeyboard = NO;
    }
    return NO;
}


#pragma mark -- setter/getter
-(void)refreshDataSource:(NSMutableArray *)listData{
    self.data = [listData mutableCopy];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}



#pragma mark--UITableViewDataSource,UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    //从缓冲区中获取已有的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    SearchFoodModel *model =  self.data[indexPath.row];
    cell.textLabel.text = model.ingredientName;
    cell.detailTextLabel.text = model.categoryName;
    
    return cell;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tableViewDidSelectRow:)]) {
        [self.delegate tableViewDidSelectRow:indexPath.row];
    }
    SearchFoodModel *model =  self.data[indexPath.row];
    self.searchBar.text =  model.ingredientName;
    [self hiden];
}



//隐藏
-(void)hiden {
    [self.searchBar resignFirstResponder];
    self.tableView.hidden = YES;
}


///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {

    float heightX =  self.data.count * 40;
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMinY(self.frame) - 5 -heightX, CGRectGetWidth(self.searchBar.frame), self.data.count * 40);

    isPopKeyboad = YES;
    
    
}



///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    isPopKeyboad = NO;
    //如果点击的是 tableview现在的区域,就不要改变 frame 的位置.
    if(!isSelectListPopkeyboard){
        self.tableView.frame = CGRectMake(CGRectGetMinX(self.searchBar.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.searchBar.frame), self.data.count * 40);
    }
    


}


@end
