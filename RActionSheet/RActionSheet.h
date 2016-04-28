//
//  RActionSheet.h
//  RActionSheet
//
//  Created by 任晓雷 on 16/3/29.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

//由于原生的actionsheet不能设置字体颜色以及如果行数比较多的时候它会沾满整个屏幕，我觉得不好看，所以封装了一个可以修改字体颜色，当sheet高度大于一定高度是可以滚动，选中某一行采用bolock
#import <UIKit/UIKit.h>
typedef void (^selectRowBlock)(NSInteger row);
@interface RActionSheet : UIViewController
@property (nonatomic, strong) NSArray * titlesArray;//sheetTexts;
//初始化
+ (RActionSheet *)sheet;
//在哪个controller里显示
- (void)showToController:(UIViewController *)controller;

//sheet.sheetTitle(@"标题").sheetTitleColor(0x666666);
//可用上面链式方式设置以下偏好
- (RActionSheet *(^)(CGFloat font))cellTextFont;//cell里文字font
- (RActionSheet *(^)(CGFloat))cellHeitht;//cell高度
- (RActionSheet *(^)(int hex))cellTextColor;//cell文字颜色
- (RActionSheet *(^)(NSString * title))sheetTitle;//标题
- (RActionSheet *(^)(int hex))sheetTitleColor;//标题颜色
- (RActionSheet *(^)(int hex))cancelButtonTextColor;//取消按钮颜色

- (void)didsSelectedBlock:(selectRowBlock)selectedBlock;//选中某一行
@end
