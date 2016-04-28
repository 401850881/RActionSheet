//
//  ViewController.m
//  RActionSheet
//
//  Created by 任晓雷 on 16/3/29.
//  Copyright © 2016年 任晓雷. All rights reserved.
//

#import "ViewController.h"
#import "RActionSheet.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeVC:(id)sender {
    
    RActionSheet * sheet = [RActionSheet sheet];
    sheet.titlesArray = @[@"one", @"two", @"three", @"four"];
    sheet.sheetTitle(@"标题").sheetTitleColor(0x666666);
    sheet.cellTextFont(18).cellTextColor(0x666666).cancelButtonTextColor(0x666666);
    [sheet didsSelectedBlock:^(NSInteger row) {
        NSLog(@"%ld", row);
    }];
    [sheet showToController:self];
}

@end
