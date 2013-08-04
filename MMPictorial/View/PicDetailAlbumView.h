//
//  PicDetailAlbumView.h
//  MMPictorial
//
//  Created by han chao on 13-4-23.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlbumModel;

@interface PicDetailAlbumView : UIView

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIView *imageContener;

@property (nonatomic,retain) IBOutlet UIView *titlContainerView;

@property (nonatomic,retain) AlbumModel *albumModel;
@property (nonatomic,retain) NSArray *picArray;

-(void)releaseSubViewsImage;

-(void)reloadSubViewsImage;

-(void)setCurrentPicId:(NSString *)picId;


@end
