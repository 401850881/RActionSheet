//
//  RActionSheet.m
//  RActionSheet
//
//  Created by 任晓雷 on 16/3/29.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "RActionSheet.h"
#import "ActionSheetCell.h"

#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RActionSheet ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (assign, nonatomic) CGFloat sheetCellHeight;
@property (assign, nonatomic) CGFloat sheetTextFont;
@property (nonatomic, strong) NSString* headTitle;//标题
@property (nonatomic, strong) UIColor * sheetTextColor;
@property (nonatomic, strong) UIColor * titleTextColor;
@property (nonatomic, strong) UIColor * cancelColor;
@property (nonatomic, copy)   selectRowBlock selectRowBlock;

@end

@implementation RActionSheet

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _tableView.layer.borderColor = UIColorFromRGB(191, 191, 191).CGColor;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 11;
    _cancelButton.layer.borderColor = UIColorFromRGB(191, 191, 191).CGColor;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.cornerRadius = 11;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    _tableView.showsVerticalScrollIndicator = NO;
    if (_headTitle.length) {
        _tableView.tableHeaderView = [self tabHeadView];
    }
    
    _tableViewHeight.constant = [self height];
    [_cancelButton setTitleColor:_cancelColor forState:UIControlStateNormal];
}

- (CGFloat)height{
    CGFloat tabHeight;
    _sheetCellHeight = _sheetCellHeight ? _sheetCellHeight : 50;
    tabHeight = _titlesArray.count * _sheetCellHeight;
    if (_headTitle.length) {
        tabHeight += 40;
    }
    if (tabHeight > [[UIScreen mainScreen] bounds].size.height * 0.61 - 65) {
        _tableView.scrollEnabled = YES;
    }else{
        _tableView.scrollEnabled = NO;
    }
    return tabHeight;
}

- (IBAction)cancel:(id)sender {
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

#pragma tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTitteIndentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLable.text = _titlesArray[indexPath.row];
    cell.titleLable.font = _sheetTextFont ? [UIFont systemFontOfSize:_sheetTextFont] : [UIFont systemFontOfSize:18];
    if (_sheetTextColor) {
        cell.titleLable.textColor = _sheetTextColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _sheetCellHeight ? _sheetCellHeight : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cancel:nil];
    _selectRowBlock(indexPath.row);
}



//手势跟tableView冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - 初始化
+ (RActionSheet *)sheet{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ActionSheet" bundle:nil];
    RActionSheet * sheetVC = [sb instantiateViewControllerWithIdentifier:@"sheet"];
    return sheetVC;
}

- (void)showToController:(UIViewController *)controller{
    [controller.view.window addSubview:self.view];
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _bottomMargin.constant = -(_tableView.frame.size.height + 10 + _cancelButton.frame.size.height);
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _bottomMargin.constant = 15;
        [self.view layoutIfNeeded];
    }];
}

- (UIView *)tabHeadView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, view.frame.size.width, 16)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.text = _headTitle;
    titleLable.textColor = _titleTextColor ? _titleTextColor : UIColorFromRGB(184, 184, 184);
    [view addSubview:titleLable];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height -1, view.frame.size.width, 0.5)];
    line.backgroundColor = UIColorFromRGB(181, 181, 181);
    [view addSubview:line];
    return view;
}

- (RActionSheet *(^)(CGFloat font))cellTextFont{
    return ^(CGFloat font){
        self.sheetTextFont = font;
        return self;
    };
}

- (RActionSheet *(^)(CGFloat))cellHeitht{
    return ^(CGFloat height){
        self.sheetCellHeight = height;
        return self;
    };
}

- (RActionSheet *(^)(NSString *))sheetTitle{
    return ^(NSString * title){
        self.headTitle = title;
        return self;
    };
}

- (RActionSheet *(^)(int))sheetTitleColor{
    return ^(int hex){
        _titleTextColor = UIColorFromHex(hex);
        return self;
    };
}

- (RActionSheet *(^)(int))cellTextColor{
    return ^(int hex){
        _sheetTextColor = UIColorFromHex(hex);
        return self;
    };
}

- (RActionSheet *(^)(int))cancelButtonTextColor{
    return ^(int hex){
        _cancelColor = UIColorFromHex(hex);
        return self;
    };
}

- (void)didsSelectedBlock:(selectRowBlock)selectedBlock{
    _selectRowBlock = selectedBlock;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
