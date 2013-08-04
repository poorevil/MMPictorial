//
//  PicDetailAlbumPaginationInterface.m
//  MMPictorial
//
//  Created by han chao on 13-4-22.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailAlbumPaginationInterface.h"

#import "JSONKit.h"

#import "PicDetailModel.h"

@implementation PicDetailAlbumPaginationInterface

-(void)getPicDetailAlbumByPageNum:(NSInteger)pageNum andAlbumId:(NSString *)albumId
{
    _pageNum = pageNum;
    
    NSString *url =
    [NSString stringWithFormat:@"http://vps.taoxiaoxian.com/interface/picdetail_album_pagination?p=%d&cid=1&albumId=%@"
                     ,pageNum,albumId];
    
    self.interfaceUrl = url;
    self.baseDelegate = self;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
//[
// {
//     "albunm_id": "22452075",
//     "user_id": "75105614",
//     "description": "韩版儿童发夹，女童红色绸缎发夹，红色与绿色的碰撞，别样的风情美！",
//     "taoke_price": "7.80",
//     "pid": "66000437",
//     "root_cate_id": 0,
//     "height": 220,
//     "width": 220,
//     "cate_id": 9,
//     "time": "2013-03-24 16:03:10",
//     "taoke_title": "儿童头饰 女童红色绸缎发夹 发饰 儿童马尾夹",
//     "pic_path": "http://img02.taobaocdn.com/imgextra/i2/15614022777567581/T1y8RSXwRXXXXXXXXX_!!75105614-0-pix.jpg",
//     "albunm_name": "咔哇伊发饰萌翻天~",
//     "taoke_num_iid": "21467740846"
// },
// ...
// ]
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            NSMutableArray *resultArray = [NSMutableArray array];
            
            for (NSDictionary *picDict in jsonObj) {
                
                PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
                
                pdm.albumId = [picDict objectForKey:@"albunm_id"];
                pdm.userId = [picDict objectForKey:@"user_id"];
                pdm.descTitle = [picDict objectForKey:@"description"];
                pdm.taokePrice = [picDict objectForKey:@"taoke_price"];
                pdm.pid = [picDict objectForKey:@"pid"];
                pdm.rootCateId = [[picDict objectForKey:@"root_cate_id"] integerValue];
                pdm.height = [[picDict objectForKey:@"height"] integerValue];
                pdm.width = [[picDict objectForKey:@"width"] integerValue];
                pdm.cateId = [[picDict objectForKey:@"cate_id"] integerValue];
                pdm.time = [picDict objectForKey:@"time"];
                pdm.taokeTitle = [picDict objectForKey:@"taoke_title"];
                pdm.picUrl = [picDict objectForKey:@"pic_path"];
                pdm.albumName = [picDict objectForKey:@"albunm_name"];
                pdm.taokeNumiid = [picDict objectForKey:@"taoke_num_iid"];
                
                [resultArray addObject:pdm];
                
            }
            
            [self.delegate getPicDetailAlbumByPageNumDidFinished:resultArray pageNum:_pageNum];
            
        }
        @catch (NSException *exception) {
            [self.delegate getPicDetailAlbumByPageNumDidFailed:@"获取失败"
                                                       pageNum:_pageNum];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPicDetailAlbumByPageNumDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]
                                               pageNum:_pageNum];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
