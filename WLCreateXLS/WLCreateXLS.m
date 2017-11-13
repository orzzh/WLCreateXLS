//
//  WLCreateXLS.m
//  WLCreateXLS
//
//  Created by 张子豪 on 2017/11/13.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import "WLCreateXLS.h"

@interface WLCreateXLS()<
UIDocumentInteractionControllerDelegate
>
@end
@implementation WLCreateXLS

- (instancetype)initWithDelegate:(id<WLCreateXLSDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}


- (void)createXlsWithFiletitle:(NSString *)title rowTitle:(NSArray *)rowTitle list:(NSArray *)list isShare:(BOOL)isShare
{
    
   
    NSMutableString *fileStr = [self createDatatitle:rowTitle list:list];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData *fileData = [fileStr dataUsingEncoding:NSUTF16StringEncoding];
    //建立文件夹
    NSString *Dir = [NSString stringWithFormat:@"%@/Documents/XLS/",NSHomeDirectory()];
    BOOL isDir =NO;
    BOOL existed = [manager fileExistsAtPath:Dir isDirectory:&isDir];
    if ( !(isDir ==YES && existed == YES) ){//如果没有文件夹则创建
        [manager createDirectoryAtPath:Dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@%@",Dir,[self checkXLS:title]];
    NSLog(@"filepath %@",filePath);
    BOOL res = [manager createFileAtPath:filePath contents:fileData attributes:nil];
    
    //返回创建状态
    if (self.delegate) {
        [self.delegate createWithStatus:res];
    }
    
    //分享
    if (isShare && res) {
        [self shareWithName:filePath];
    }
}


- (NSArray *)getList{
    NSMutableArray *ListAry = [NSMutableArray new];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/XLS/",NSHomeDirectory()];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[manager contentsOfDirectoryAtPath:filePath error:nil]];
    if (tempFileList && tempFileList.count != 0) {
        for (NSString *file in tempFileList) {
            if ([file rangeOfString:@".xls"].location != NSNotFound ) {
                [ListAry addObject:file];
            }
        }
    }
    return ListAry;
}


- (void)shareWithName:(NSString *)name{
    if (![self checkLocal:name]) {
        return;
    }
    UIViewController *vc = (UIViewController *)self.delegate;
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/XLS/%@",NSHomeDirectory(),[self checkXLS:name]];
    UIDocumentInteractionController *docu = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    docu.delegate = self;
    CGRect rect = CGRectMake(0, 0, 320, 300);
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL ret  = [docu presentOpenInMenuFromRect:rect inView:vc.view animated:YES];
        BOOL rets = [docu presentPreviewAnimated:YES];
        if (ret && rets) {
            NSLog(@"完成");
        }
    });


    
}


- (void)deleteWithName:(NSString *)name{
    if (![self checkLocal:name]) {
        return;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/XLS/%@",NSHomeDirectory(),[self checkXLS:name]];
    BOOL res = [manager removeItemAtPath:filePath error:nil];
    if (self.delegate) {
        [self.delegate deleteWithStatus:res];
    }
}

- (void)restWithOldname:(NSString *)oldname newName:(NSString *)newname{
    if (![self checkLocal:oldname]) {
        return;
    }
    for (NSString *list in [self getList]) {
         NSString *temp = [NSString stringWithFormat:@"%@1",newname];
        if ([list isEqualToString:[self checkXLS:newname]]) {
            newname = temp;
        }
    }

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *oldfilePath = [NSString stringWithFormat:@"%@/Documents/XLS/%@",NSHomeDirectory(),[self checkXLS:oldname]];
    NSString *newfilePath = [NSString stringWithFormat:@"%@/Documents/XLS/%@",NSHomeDirectory(),[self checkXLS:newname]];
    BOOL res = [manager moveItemAtPath:oldfilePath toPath:newfilePath error:nil];
    if (self.delegate) {
        [self.delegate restWithStatus:res];
    }
}

- (void)removeAll{
    NSArray *ary = [self getList];
    for (NSString *name in ary) {
        [self deleteWithName:name];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return (UIViewController *)self.delegate;
}

#pragma  makr - 数据处理
- (NSMutableString *)createDatatitle:(NSArray *)rowTitle list:(NSArray *)list{
    NSMutableString *dataString = [NSMutableString new];
//    excel 头处理
    for (int i = 0; i<rowTitle.count; i++) {

        NSString *temp = @"";
        if (i == rowTitle.count - 1) {
           temp = [NSString stringWithFormat:@"%@\n",rowTitle[i]];
        }else{
            temp = [NSString stringWithFormat:@"%@\t",rowTitle[i]];
        }
        [dataString appendString:temp];
    }

    //excel 列处理
    for (int i = 0; i<list.count; i++) {
        NSArray *subAry = [list objectAtIndex:i];
        for (int i = 0; i<subAry.count; i++) {
            NSString *temp = @"";
            if (i == rowTitle.count - 1) {
                temp = [NSString stringWithFormat:@"%@\n",subAry[i]];
            }else{
                temp = [NSString stringWithFormat:@"%@\t",subAry[i]];
            }
            [dataString appendString:temp];
        }
    }
    return dataString;
}

//检验本地是否含有该.xls
- (BOOL)checkLocal:(NSString *)str{
    NSArray  *ary = [self getList];
    str = [self checkXLS:str];
    if (ary.count == 0) {
        NSLog(@"本地没有文件");
    }
    for (NSString *name in ary) {
        if ([name isEqualToString:str]) {
            return YES;
        }
    }
    NSLog(@"未找到需要操作的文件");
    return NO;
}

//检验是否含有后缀 .xls
- (NSString *)checkXLS:(NSString *)str{
    if ([str rangeOfString:@".xls"].location == NSNotFound) {
        str = [NSString stringWithFormat:@"%@.xls",str];
    }
    return str;
}

@end
