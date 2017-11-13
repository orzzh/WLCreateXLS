//
//  WLCreateXLS.h
//  WLCreateXLS
//
//  Created by 张子豪 on 2017/11/13.
//  Copyright © 2017年 张子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WLCreateXLSDelegate

@required
- (void)deleteWithStatus:(BOOL)isSuccess;//删除
- (void)createWithStatus:(BOOL)isSuccess;//创建
- (void)restWithStatus:(BOOL)isSuccess;  //重命名

@end

@interface WLCreateXLS : NSObject

@property (nonatomic,weak) id<WLCreateXLSDelegate>  delegate;


- (instancetype)initWithDelegate:(id<WLCreateXLSDelegate>)delegate;

/**
 ** 创建文件
 ** @param title    文件名
 ** @param rowTitle 第一列title数组
 ** @param list     内容数组->list内每一行 为一个数组
 ** @param isShare  储存成功是否分享
 **/
- (void)createXlsWithFiletitle:(NSString *)title rowTitle:(NSArray *)rowTitle list:(NSArray *)list isShare:(BOOL)isShare;

/**
 ** 获取文件.xls列表
 **/
- (NSArray *)getList;

/**
 ** 分享文件
 **/
- (void)shareWithName:(NSString *)name;

/**
 ** 删除文件
 **/
- (void)deleteWithName:(NSString *)name;

/**
 ** 重命名
 **/
- (void)restWithOldname:(NSString *)oldname newName:(NSString *)newname;

/**
 ** 清空文件
 **/
- (void)removeAll;


@end
