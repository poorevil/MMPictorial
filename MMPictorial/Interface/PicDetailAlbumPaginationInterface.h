//
//  PicDetailAlbumPaginationInterface.h
//  MMPictorial
//
//  用于图片详细页面中，图集分页加载接口
//
//  Created by han chao on 13-4-22.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "BaseInterface.h"

@protocol PicDetailAlbumPaginationInterfaceDelegate;

@interface PicDetailAlbumPaginationInterface : BaseInterface <BaseInterfaceDelegate>{
    NSInteger _pageNum;
}

@property (nonatomic,assign) id<PicDetailAlbumPaginationInterfaceDelegate> delegate;

-(void)getPicDetailAlbumByPageNum:(NSInteger)pageNum andAlbumId:(NSString *)albumId;

@end

@protocol PicDetailAlbumPaginationInterfaceDelegate <NSObject>

-(void)getPicDetailAlbumByPageNumDidFinished:(NSArray *)array pageNum:(NSInteger)pageNum;
-(void)getPicDetailAlbumByPageNumDidFailed:(NSString *)errorMsg pageNum:(NSInteger)pageNum;

@end

