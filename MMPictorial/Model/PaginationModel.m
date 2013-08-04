//
//  PaginationModel.m
//  MMPictorial
//
//  Created by han chao on 13-4-22.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PaginationModel.h"

@implementation PaginationModel

-(void)dealloc
{
    self.currentPagePicDetailArray = nil;
    self.nextPagePicDetailArray = nil;
    self.previousPagePicDetailArray = nil;
    
    [super dealloc];
}

@end
