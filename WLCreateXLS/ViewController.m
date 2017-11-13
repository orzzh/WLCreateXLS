//
//  ViewController.m
//  WLCreateXLS
//
//  Created by 张子豪 on 2017/11/13.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "ViewController.h"
#import "WLCreateXLS.h"
#import "XLSTableViewController.h"

@interface ViewController ()<WLCreateXLSDelegate>

{
    WLCreateXLS *xls;
    UITextField *text;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    xls = [[WLCreateXLS alloc]initWithDelegate:self];

    NSArray *title= @[@"生成XLS文件",@"获取XLS文件",@"清除XLS文件",@"分享XLS文件",@"重命名XLS文件"];
    for (int i = 0 ; i<3; i++) {
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeSystem];
        createButton.frame = CGRectMake(self.view.center.x-100, self.view.center.y-120+40*i, 200, 20);
        createButton.tag = i;
        [createButton setTitle:title[i] forState:UIControlStateNormal];
        [createButton addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createButton];
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:4];
    text = [[UITextField alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, btn.frame.size.width,40)];
    text.backgroundColor = [UIColor grayColor];
    [self.view addSubview:text];

}

- (void)btnAct:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self createXLSFile];
            break;
        case 1:
            [self getXLS];
            break;
        case 2:
            [self delXLS];
            break;
        case 3:
//            [self shareXLS];
            break;
        default:
//            [self restXLS];
            break;
    }
}

- (void)createXLSFile{

    
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // title
    [xlsDataMuArr addObject:@"编号"];
    [xlsDataMuArr addObject:@"姓名"];
    [xlsDataMuArr addObject:@"性别"];
    [xlsDataMuArr addObject:@"年龄"];
    [xlsDataMuArr addObject:@"身高"];
    [xlsDataMuArr addObject:@"体重"];
    
    //内容
    NSMutableArray  *xlsDataList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i ++) {
        NSMutableArray *lisAry = [[NSMutableArray alloc]init];
        [lisAry addObject:@"89757"];
        [lisAry addObject:@"张三"];
        [lisAry addObject:@"男"];
        [lisAry addObject:@"33"];
        [lisAry addObject:@"189cm"];
        [lisAry addObject:@"75kg"];
        [xlsDataList addObject:lisAry];
    }
    [xls createXlsWithFiletitle:@"1111" rowTitle:xlsDataMuArr list:xlsDataList isShare:NO];
    [xls createXlsWithFiletitle:@"2222" rowTitle:xlsDataMuArr list:xlsDataList isShare:NO];
    [xls createXlsWithFiletitle:@"3333" rowTitle:xlsDataMuArr list:xlsDataList isShare:NO];

}

- (void)delXLS{
    [xls removeAll];
}

- (void)getXLS{
    
    XLSTableViewController *vc = [[XLSTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareXLS{
    NSString *path = [[xls getList] objectAtIndex:0];
    [xls shareWithName:path];
}

- (void)restXLS{
    NSString *path = [[xls getList] objectAtIndex:0];
    if (text.text.length != 0 ) {
        [xls restWithOldname:path newName:text.text];
    }else{
        NSLog(@"新字符串为空");
    }
}


#pragma mark - delegate

- (void)deleteWithStatus:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"删除成功");
        return;
    }
    NSLog(@"删除失败");
}

- (void)createWithStatus:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"创建成功");
        return;
    }
    NSLog(@"创建失败");
}

- (void)restWithStatus:(BOOL)isSuccess{
    if (isSuccess) {
        NSLog(@"重命名成功");
        return;
    }
    NSLog(@"重命名失败");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
