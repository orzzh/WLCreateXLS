//
//  XLSTableViewController.m
//  WLCreateXLS
//
//  Created by 张子豪 on 2017/11/13.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "XLSTableViewController.h"
#import "WLCreateXLS.h"
@interface XLSTableViewController ()<
WLCreateXLSDelegate,
UITableViewDataSource,
UITableViewDelegate
>
{
    UIWebView *_ExcelWebView;
}
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,strong)WLCreateXLS *manager;

@end

@implementation XLSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    self.dataAry = [self.manager getList];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *ExcelName = [NSString stringWithFormat:@"%@",self.dataAry[indexPath.row]];
    _ExcelWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _ExcelWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [_ExcelWebView setClipsToBounds:YES];//设置为界限
    [_ExcelWebView setScalesPageToFit:YES];//页面设置为合适
    [self showExcelData:ExcelName];
    [self.view addSubview:_ExcelWebView];
}

- (void) showExcelData:(NSString *)ExcelName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/XLS/%@",NSHomeDirectory(),ExcelName];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_ExcelWebView loadRequest:request];

    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *toTop = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"重命名" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"重命名");
        [weakSelf.manager restWithOldname:[tableView cellForRowAtIndexPath:indexPath].textLabel.text newName:@"重命名"];
        [weakSelf reloadData];
        [tableView setEditing:NO animated:YES];
    }];
    toTop.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *two = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"分享" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"分享");
        [tableView setEditing:NO animated:YES];
        [weakSelf.manager shareWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }];
    two.backgroundColor = [UIColor grayColor];

    UITableViewRowAction *thre = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"删除");
        [weakSelf.manager deleteWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [weakSelf reloadData];
        [tableView setEditing:NO animated:YES];
    }];
    thre.backgroundColor =[UIColor redColor];

    return @[thre,two,toTop];
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


#pragma  mark - lazyLoad

- (NSArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [self.manager getList];
    }
    return _dataAry;
}

- (WLCreateXLS *)manager{
    if (!_manager) {
        _manager = [[WLCreateXLS alloc]initWithDelegate:self];
    }
    return _manager;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
