//
//  PicDetailInterface.m
//  BabyPictorial
//
//  Created by han chao on 13-3-25.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailInterface.h"

#import "JSONKit.h"

#import "PicDetailModel.h"
#import "AlbumModel.h"
#import "PaginationModel.h"

@implementation PicDetailInterface

-(void)getPicDetailByPid:(NSString *)pid
{
    self.interfaceUrl = [NSString stringWithFormat:@"http://vps.taoxiaoxian.com/interface/picdetail_v2?pid=%@&cid=1",pid];
    self.baseDelegate = self;
    
    [self connect];
}


#pragma mark - BaseInterfaceDelegate
//{
//    "albumPageSize": 6,
//    "albumPageAmount": 20,
//    "currentPageNo": 3,
//    "albumPicAmount": 10,
//    "albumPagination": {
//        "currentPage": {
//            "pageNo": 3,
//            "picArray": [
//                         {
//                             "taoke_price": "46.00",
//                             "pid": "71263265",
//                             "taoke_title": "女童T恤 2013春装新款 百搭春秋款 凸印彩色螺纹亮片向日葵上衣",
//                             "pic_desc": "百搭凸印彩色螺纹亮片向日葵上衣,简单的T恤,不规则的涂鸦螺纹,采用特殊的浮雕印刷工艺, 点缀缤纷~",
//                             "pic_path": "http://img02.taobaocdn.com/imgextra/i2/10912021924954413/T178afXrtdXXXXXXXX_!!705450912-0-pix.jpg",
//                             "taoke_num_iid": "17596282334"
//                         },
//                         ...
//                         ]
//        },
//        "nextPage": {
//            "pageNo": 4,
//            "picArray": [
//                         {
//                             "taoke_price": "39.90",
//                             "pid": "71260699",
//                             "taoke_title": "女童休闲裤 2013春装新款童装 碎花田园风长裤 韩版哈伦裤",
//                             "pic_desc": "软软的针织棉小哈伦裤造型，使它成为单穿或打底都可以的针织裤，版型略松但不肥大，属于修身的裤型~",
//                             "pic_path": "http://img03.taobaocdn.com/imgextra/i3/10912021924706444/T1r6efXABeXXXXXXXX_!!705450912-0-pix.jpg",
//                             "taoke_num_iid": "23762232269"
//                         },
//                         ...
//                         ]
//        },
//        "previousPage": {
//            "pageNo": 2,
//            "picArray": [
//                         {
//                             "taoke_price": "65.00",
//                             "pid": "71274032",
//                             "taoke_title": "女童牛仔裤 童装2013春装新款长裤 韩版儿童针织柔软弹力牛仔裤子",
//                             "pic_desc": "韩版儿童针织柔软弹力牛仔裤子,深深浅浅的牛仔蓝像那次旅行看到的大海,层层递进的海水诱惑着你一点一点的靠近,呼吸自由空气放飞一种心情~",
//                             "pic_path": "http://img02.taobaocdn.com/imgextra/i2/10912021926782412/T11r9gXCdcXXXXXXXX_!!705450912-0-pix.jpg",
//                             "taoke_num_iid": "23162252195"
//                         },
//                         ...
//                         ]
//        }
//    },
//    "picDetail": {
//        "albunm_id": "22805826",
//        "user_id": "705450912",
//        "description": "长袖韩版百搭儿童口袋字母T恤,舒适的T恤棉质,休闲随意的风格~",
//        "taoke_price": "49.90",
//        "pid": "71262089",
//        "root_cate_id": 0,
//        "height": 220,
//        "width": 220,
//        "cate_id": 9,
//        "time": "2013-04-17 22:03:25",
//        "taoke_title": "女童T恤 童装2013春装新款打底衫 长袖韩版百搭儿童口袋字母T恤",
//        "pic_path": "http://img04.taobaocdn.com/imgextra/i4/10912021928242632/T1ZMWfXChfXXXXXXXX_!!705450912-0-pix.jpg",
//        "albunm_name": "时尚女童装 给宝贝棉花糖般的爱",
//        "taoke_num_iid": "17499494539"
//    },
//    "recommendAlbum": [
//                       {
//                           "albunmId": "22579429",
//                           "albunmName": "变身俏皮小公主 连衣裙美艳无敌",
//                           "picDetail": [
//                                         {
//                                             "pic_desc": "春装裙子牛仔裙，纯棉蕾丝花边搭配PU皮小装饰，金属质感扣子简洁大气。PU皮腰带衬托出衣服的质感。",
//                                             "pic_path": "http://img04.taobaocdn.com/imgextra/i4/15576021093341606/T1zJVZXtlcXXXXXXXX_!!176835576-0-pix.jpg",
//                                             "pid": "67254892"
//                                         },
//                                         {
//                                             "pic_desc": "满满的花朵十足的田园气息，散发着一种清新自然的感觉，领口的珠子装饰很别致，甜美可爱。",
//                                             "pic_path": "http://img02.taobaocdn.com/imgextra/i2/15576021103924983/T1qSV0XwBaXXXXXXXX_!!176835576-0-pix.jpg",
//                                             "pid": "67255035"
//                                         },
//                                         {
//                                             "pic_desc": "无袖雪纺裙连衣裙，蕾丝与雪纺面料的拼接，时尚优雅。腰后大大的蝴蝶结，非常的甜美可爱，宛如童话里的小公主。",
//                                             "pic_path": "http://img03.taobaocdn.com/imgextra/i3/15576021100325097/T1Pgd1Xs0XXXXXXXXX_!!176835576-0-pix.jpg",
//                                             "pid": "67256001"
//                                         }
//                                         ]
//                       },
//                       ...
//                       ]
//    }
-(void)parseResult:(ASIHTTPRequest *)request{
    NSString *jsonStr = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    id jsonObj = [jsonStr objectFromJSONString];
    
    [jsonStr release];
    
    if (jsonObj) {
        @try {
            NSDictionary *item = jsonObj;
            
            //分页信息
            PaginationModel *pagination = [[[PaginationModel alloc] init] autorelease];

            pagination.pageSize = [[item objectForKey:@"albumPageSize"] integerValue];
            pagination.pageAmount = [[item objectForKey:@"albumPageAmount"] integerValue];
            pagination.currentPageNo = [[item objectForKey:@"currentPageNo"] integerValue];
            pagination.totalPicSize = [[item objectForKey:@"albumPicAmount"] integerValue];
            
            NSDictionary *albumPaginationDict = [item objectForKey:@"albumPagination"];
            
            //当前页列表
            NSArray *currentPagePicArray = [[albumPaginationDict objectForKey:@"currentPage"] objectForKey:@"picArray"];

            NSMutableArray *currentPdmArray = [NSMutableArray array];
            for (NSDictionary *picDict in currentPagePicArray) {
                PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
                
                pdm.taokePrice = [picDict objectForKey:@"taoke_price"];
                pdm.pid = [picDict objectForKey:@"pid"];
                pdm.taokeTitle = [picDict objectForKey:@"taoke_title"];
                pdm.picUrl = [picDict objectForKey:@"pic_path"];
                pdm.descTitle = [picDict objectForKey:@"pic_desc"];
                pdm.taokeNumiid = [picDict objectForKey:@"taoke_num_iid"];
                
                [currentPdmArray addObject:pdm];
            }
            
            pagination.currentPagePicDetailArray = currentPdmArray;
            
            //下一页列表
            NSArray *nextPagePicArray = [[albumPaginationDict objectForKey:@"nextPage"] objectForKey:@"picArray"];
            NSMutableArray *nextPdmArray = [NSMutableArray array];
            for (NSDictionary *picDict in nextPagePicArray) {
                PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
                
                pdm.taokePrice = [picDict objectForKey:@"taoke_price"];
                pdm.pid = [picDict objectForKey:@"pid"];
                pdm.taokeTitle = [picDict objectForKey:@"taoke_title"];
                pdm.picUrl = [picDict objectForKey:@"pic_path"];
                pdm.descTitle = [picDict objectForKey:@"pic_desc"];
                pdm.taokeNumiid = [picDict objectForKey:@"taoke_num_iid"];
                
                [nextPdmArray addObject:pdm];
            }
            
            pagination.nextPagePicDetailArray = nextPdmArray;
            
            //上一页列表
            NSArray *previousPagePicArray = [[albumPaginationDict objectForKey:@"previousPage"] objectForKey:@"picArray"];
            NSMutableArray *previousPdmArray = [NSMutableArray array];
            for (NSDictionary *picDict in previousPagePicArray) {
                PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
                
                pdm.taokePrice = [picDict objectForKey:@"taoke_price"];
                pdm.pid = [picDict objectForKey:@"pid"];
                pdm.taokeTitle = [picDict objectForKey:@"taoke_title"];
                pdm.picUrl = [picDict objectForKey:@"pic_path"];
                pdm.descTitle = [picDict objectForKey:@"pic_desc"];
                pdm.taokeNumiid = [picDict objectForKey:@"taoke_num_iid"];
                
                [previousPdmArray addObject:pdm];
            }
            
            pagination.previousPagePicDetailArray = previousPdmArray;
            
            
            NSDictionary *picDict = [item objectForKey:@"picDetail"];
            
            PicDetailModel *pdm = [[[PicDetailModel alloc] init] autorelease];
            pdm.paginationModel = pagination;
            
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
            
            
            /*
             *recommendAlbum
             */
            NSArray *recommendAlbum = [item objectForKey:@"recommendAlbum"];
            
            for (NSDictionary *dict in recommendAlbum) {
                
                AlbumModel *am = [[AlbumModel alloc] init];
                am.albumId = [dict objectForKey:@"albunmId"];
                am.albumName = [dict objectForKey:@"albunmName"];
                
                NSArray *picDetails = [dict objectForKey:@"picDetail"];
                
                for (NSDictionary *dict in picDetails) {
                    
                    PicDetailModel *pdm = [[PicDetailModel alloc] init];
                    
                    pdm.pid = [dict objectForKey:@"pid"];
                    pdm.picUrl = [dict objectForKey:@"pic_path"];
                    pdm.descTitle = [dict objectForKey:@"pic_desc"];
                    
                    [am.picArray addObject:pdm];
                    
                    [pdm release];
                }
                                    
                [pdm.recommendAlbumArray addObject:am];
                [am release];
            }
            
            /*
             *picModelInAlbum
             */
            NSArray *picOwnerAlbum = [item objectForKey:@"picModelInAlbum"];
                
            AlbumModel *am = [[AlbumModel alloc] init];
            am.albumId = pdm.albumId;
            am.albumName = pdm.albumName;
            
            for (NSDictionary *dict in picOwnerAlbum) {
                
                PicDetailModel *pdm = [[PicDetailModel alloc] init];
                
                pdm.pid = [dict objectForKey:@"pid"];
                pdm.picUrl = [dict objectForKey:@"pic_path"];
                pdm.descTitle = [dict objectForKey:@"pic_desc"];
                
                [am.picArray addObject:pdm];
                
                [pdm release];
            }
            
            pdm.ownerAlbum = am;
            [am release];
            
            
            [self.delegate getPicDetailDidFinished:pdm];

        }
        @catch (NSException *exception) {
            NSLog(@"---%@",exception.description);
            
            [self.delegate getPicDetailDidFailed:@"获取失败"];
        }
    }
}

-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPicDetailDidFailed:[NSString stringWithFormat:@"获取失败！(%@)",error]];
}

-(void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end
