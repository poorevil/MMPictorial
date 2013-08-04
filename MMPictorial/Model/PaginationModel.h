//
//  PaginationModel.h
//  MMPictorial
//
//  Created by han chao on 13-4-22.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaginationModel : NSObject

@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageAmount;
@property (nonatomic,assign) NSInteger currentPageNo;
@property (nonatomic,assign) NSInteger totalPicSize;//图集中图片总数量

//当前页图片列表
@property (nonatomic,retain) NSArray *currentPagePicDetailArray;
//前一页图片列表
@property (nonatomic,retain) NSArray *previousPagePicDetailArray;
//后一页图片列表
@property (nonatomic,retain) NSArray *nextPagePicDetailArray;



@end
