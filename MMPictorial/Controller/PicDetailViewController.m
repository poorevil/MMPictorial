//
//  PicDetailViewController.m
//  BabyPictorial
//
//  Created by han chao on 13-3-21.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "PicDetailInterface.h"    
#import "EGOImageView.h"

#import "PicDetailModel.h"
#import "AlbumModel.h"

#import "PicDetailAlbumView.h"

#import "RecommendAlbumView.h"

#import "DividerView.h"

#import "PicDetailTaokeMsgView.h"

#import "TaokeItemDetailInterface.h"

#import "MobClick.h"

#import "SVWebViewController.h"

#import "MBProgressHUD.h"

#import "PaginationModel.h"

#import "PicDetailAlbumPaginationInterface.h"

@interface PicDetailViewController (){
    NSInteger _totalPageAmount;
    NSInteger _currentPageNo;
    NSInteger _pageSize;
    NSInteger _totalPicSize;//图集中图片总数量
    
    
    NSInteger _currentPicIdxInAlbumArray;//当前图片在图集中的索引
}

//当前图集分页信息。key:NSNumber,页数   value:NSArray,列表
@property (nonatomic,retain) NSMutableDictionary *albumPaginationDict;

@property (nonatomic,retain) PicDetailInterface *interface;

@property (nonatomic,retain) TaokeItemDetailInterface *taokeItemDetailInterface;

@property (nonatomic,retain) PicDetailAlbumPaginationInterface *picDetailAlbumPaginationInterface;

@end

@implementation PicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (UIBarButtonItem *)createSquareBarButtonItemWithTitle:(NSString *)t
                                                 target:(id)tgt
                                                 action:(SEL)a
                                              bgImgName:(NSString *)bgImgName
                                       pressedBgImgName:(NSString *)pressedBgImgName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // Since the buttons can be any width we use a thin image with a stretchable center point
    UIImage *buttonImage = [[UIImage imageNamed:bgImgName] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:pressedBgImgName] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = [t sizeWithFont:[UIFont boldSystemFontOfSize:12.0]].width + 24.0;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    
    [button setTitle:t forState:UIControlStateNormal];
    
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return [buttonItem autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.albumPaginationDict = [NSMutableDictionary dictionary];
    
    self.descriptionLabel.text = self.picDescTitle;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.gif"]];
    
    self.interface = [[[PicDetailInterface alloc] init] autorelease];
    self.interface.delegate = self;
    [self.interface getPicDetailByPid:self.pid];
    
    
    NSString *parentTitle = nil;
    
    if (self.navigationController.viewControllers.count>1)
        parentTitle = [[[self.navigationController.viewControllers
                         objectAtIndex:self.navigationController.viewControllers.count-2] navigationItem] title];
    
    //返回
    UIBarButtonItem *backBtn = [PicDetailViewController createSquareBarButtonItemWithTitle:parentTitle==nil?@"潮流服饰精选":parentTitle
                                                                                    target:self
                                                                                    action:@selector(backAction)
                                                                                 bgImgName:@"back_btn_bg.png"
                                                                          pressedBgImgName:@"back_btn_pressed_bg.png"];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //返回首页
    UIBarButtonItem *homeBtn = [PicDetailViewController createSquareBarButtonItemWithTitle:@"潮流服饰精选"
                                                                                    target:self
                                                                                    action:@selector(homeAction)
                                                                                 bgImgName:@"home_btn_bg.png"
                                                                          pressedBgImgName:@"home_btn_pressed_bg.png"];
    self.navigationItem.rightBarButtonItem = homeBtn;
    
    
    self.navigationItem.title = self.navTitle;
    
    self.mScrollView.contentSize = self.view.frame.size;
    
    self.picScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_2.png"]];
    
    
    self.detailContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.detailContainer.layer.borderWidth = 1;
    self.rightContainer.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.85].CGColor;
    self.rightContainer.layer.borderWidth = 1;
    
    
    //默认图，先挡挡 :P
    //TODO:考虑用透明渐变或其他方式过度
    self.imageView.imageURL = self.smallPicUrl;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

-(void)setShadow
{
    //self.picContainer.superview 阴影
    self.picScrollView.superview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.picScrollView.superview.layer.shadowOpacity = 0.2;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint topLeft      = CGPointMake(0.0, 6.0);
    CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.picScrollView.superview.bounds)+3);
    CGPoint bottomRight  = CGPointMake(CGRectGetWidth(self.picScrollView.superview.bounds)+2, CGRectGetHeight(self.picScrollView.superview.bounds)+3);
    CGPoint topRight     = CGPointMake(CGRectGetWidth(self.picScrollView.superview.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.picScrollView.superview.layer.shadowPath = path.CGPath;
    
    //self.detailContainer 阴影
    self.detailContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.detailContainer.layer.shadowOpacity = 0.2;
    
    // shadow
    path = [UIBezierPath bezierPath];
    
    topLeft      = CGPointMake(0.0, 6.0);
    bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.detailContainer.bounds)+6);
    bottomRight  = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2
                               , CGRectGetHeight(self.detailContainer.bounds)+6);
    topRight     = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.detailContainer.layer.shadowPath = path.CGPath;
}

//更新scrollview高度
-(void)updateScrollViewContentSize
{
    
    CGPoint bottomPoint = CGPointZero;
    
    for (UIView *view in self.mScrollView.subviews) {
        
        bottomPoint.y = MAX(bottomPoint.y, (view.frame.size.height + view.frame.origin.y));
    }
    
    self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width
                                              , bottomPoint.y + 20);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.picDescTitle = nil;
    
    self.taokeItemDetailInterface.delegate = nil;
    self.taokeItemDetailInterface = nil;
    
    self.navTitle = nil;
    
    self.pid = nil;
    
    self.detailContainer = nil;
//    self.picContainer = nil;
    
    self.picScrollView = nil;
    
    self.interface.delegate = nil;
    self.interface = nil;
    
    self.imageView = nil;
    self.descriptionLabel = nil;
    
    self.mScrollView = nil;
    
    self.rightContainer = nil;
    
    self.smallPicUrl = nil;
    
    self.pdm = nil;
    
    self.picDetailAlbumPaginationInterface.delegate = nil;
    self.picDetailAlbumPaginationInterface = nil;
    
    [super dealloc];
}


#pragma mark - PicDetailInterfaceDelegate

-(void)getPicDetailDidFinished:(PicDetailModel *)pdm
{
    
    self.pdm = pdm;
    
    /*
     * 处理分页信息
     */
    PaginationModel *pagination = pdm.paginationModel;
    
    _currentPageNo = pagination.currentPageNo;
    _totalPageAmount = pagination.pageAmount;
    _pageSize = pagination.pageSize;
    _totalPicSize = pagination.totalPicSize;
    
    [self.albumPaginationDict setObject:pagination.currentPagePicDetailArray
                                 forKey:[NSNumber numberWithInt:_currentPageNo]];
    
//    if (pagination.nextPagePicDetailArray.count > 0) {
//        [self.albumPaginationDict setObject:pagination.nextPagePicDetailArray
//                                     forKey:[NSNumber numberWithInt:_currentPageNo+1]];
//    }
//    
//    if (pagination.previousPagePicDetailArray.count > 0) {
//        [self.albumPaginationDict setObject:pagination.previousPagePicDetailArray
//                                     forKey:[NSNumber numberWithInt:_currentPageNo-1]];
//    }
    
    //处理picScrollView
    self.picScrollView.contentSize = CGSizeMake(self.picScrollView.frame.size.width * _totalPicSize
                                                , self.picScrollView.frame.size.height);
    
    
    NSArray *currentArray = [self.albumPaginationDict objectForKey:[NSNumber numberWithInt:_currentPageNo]];
    for (NSInteger idx =0; idx < currentArray.count; idx++) {
        
        EGOImageView *imageView = [[[EGOImageView alloc] initWithFrame:CGRectMake((_currentPageNo*_pageSize+idx)*self.picScrollView.frame.size.width+20
                                                                                  , 20
                                                                                  , self.picScrollView.frame.size.width-40
                                                                                  , self.picScrollView.frame.size.height-40)]
                                   autorelease];
        imageView.tag = 99+_currentPageNo*_pageSize + idx;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.picScrollView addSubview:imageView];
    }
        
    //当前图片的索引
    NSInteger currentPicIdx =  0;
    
    NSArray *currPicArray = [self.albumPaginationDict objectForKey:[NSNumber numberWithInt:_currentPageNo]];
    for (NSInteger idx = 0; idx < currPicArray.count; idx++) {
        PicDetailModel *pdmTmp = [currPicArray objectAtIndex:idx];
        
        if ([self.pdm.pid isEqualToString:pdmTmp.pid]) {
            currentPicIdx = idx;
            break;
        }
    }
    
    for (NSInteger i =0; i<3; i++) {
        
        if ((currentPicIdx-1+i) >= 0 && (currentPicIdx-1+i) < currPicArray.count) {
            EGOImageView *image = (EGOImageView *)[self.picScrollView
                                                   viewWithTag:99+(currentPicIdx-1+i)];
            image.imageURL = [NSURL URLWithString:[[currPicArray objectAtIndex:(currentPicIdx-1+i)] picUrl]];
        }
        
    }
    
    self.picScrollView.contentOffset = CGPointMake(self.picScrollView.frame.size.width
                                                   * (_currentPageNo * _pageSize+currentPicIdx)
                                                   , 0);
    
    [self.imageView.superview removeFromSuperview];
    
    
    //====================
    
    
    self.descriptionLabel.text = pdm.descTitle;
    
    
    PicDetailAlbumView *albumView = [[[NSBundle mainBundle] loadNibNamed:@"PicDetailAlbumView"
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
    
    albumView.frame = CGRectMake( 2
                                 , 0
                                 , albumView.frame.size.width
                                 , albumView.frame.size.height);
    
    albumView.albumModel = pdm.ownerAlbum;
    albumView.picArray = pagination.currentPagePicDetailArray;
    [albumView setCurrentPicId:self.pdm.pid];
    
    [self.detailContainer addSubview:albumView];
    
    //分割线
    DividerView *dv = [[[NSBundle mainBundle] loadNibNamed:@"DividerView"
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
    
    CGRect frame = dv.frame;
    
    frame.origin.y = [[self.detailContainer.subviews lastObject] frame].origin.y
    +[[self.detailContainer.subviews lastObject] frame].size.height+20;
    
    dv.frame = frame;
    
    [self.detailContainer addSubview:dv];
    
    //推荐图集
    for (AlbumModel *am in pdm.recommendAlbumArray) {
        
        RecommendAlbumView *rav = [[[NSBundle mainBundle] loadNibNamed:@"RecommendAlbumView"
                                                                 owner:self
                                                               options:nil] objectAtIndex:0];
        
        CGRect frame = rav.frame;
        
        frame.origin.y = [[self.detailContainer.subviews lastObject] frame].origin.y
        +[[self.detailContainer.subviews lastObject] frame].size.height;
        
        rav.frame = frame;
        
        rav.albumModel = am;
        
        [self.detailContainer addSubview:rav];
        
        CGRect dcFrame = self.detailContainer.frame;
        dcFrame.size.height = (rav.frame.origin.y+rav.frame.size.height);
        
        self.detailContainer.frame = dcFrame;
        
        self.mScrollView.contentSize = CGSizeMake(self.view.frame.size.width
                                                  , self.detailContainer.frame.origin.y+self.detailContainer.frame.size.height+10);
        
        
    }
    
    [self setShadow];
    
    [self updateScrollViewContentSize];
    
    
    self.taokeItemDetailInterface = [[[TaokeItemDetailInterface alloc] init] autorelease];
    self.taokeItemDetailInterface.delegate = self;
    [self.taokeItemDetailInterface getTaokeItemDetailsByNumiid:self.pdm.taokeNumiid];
    
}

-(void)getPicDetailDidFailed:(NSString *)errorMsg
{
    NSLog(@"=======%@",errorMsg);
}


#pragma mark -homeAction
-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - EGOImageViewDelegate
//- (void)imageViewLoadedImage:(EGOImageView*)imageView
//{
//    UIView *parentView = imageView.superview;
//    
//    CGRect imageFrame = imageView.frame;
//
//    imageFrame.size.height = (CGFloat)imageFrame.size.width / (CGFloat)imageView.image.size.width  * imageView.image.size.height;
//    
//    
//    CGRect parentFrame = parentView.frame;
//    parentFrame.size.height += (imageFrame.size.height - imageView.frame.size.height);
//    parentView.frame = parentFrame;
//    
//    imageView.frame = imageFrame;
//    
//    CGRect frame = parentView.superview.frame;
//    frame.size.height = parentView.frame.size.height + parentView.frame.origin.y;
//    parentView.superview.frame = frame;
//    
//    [self setShadow];
//    
//    [self updateScrollViewContentSize];
//}

#pragma mark - TaokeItemDetailInterfaceDelegate
-(void)getTaokeItemDetailsByNumiidDidFinished:(NSString *)url
{
    self.pdm.taokeUrl = url;
    
    PicDetailTaokeMsgView *ptmv = (PicDetailTaokeMsgView *)[self.mScrollView viewWithTag:99999];
    
    if (!ptmv) {
        ptmv = [[[NSBundle mainBundle] loadNibNamed:@"PicDetailTaokeMsgView"
                                              owner:self
                                            options:nil] objectAtIndex:0];
        
        ptmv.tag = 99999;
        
        CGRect ptmvFrame = ptmv.frame;
        ptmvFrame.origin.x = self.rightContainer.frame.origin.x;
        ptmvFrame.origin.y = self.rightContainer.frame.origin.y + self.rightContainer.frame.size.height + 10;
        
        ptmv.frame = ptmvFrame;
        
        [self.mScrollView addSubview:ptmv];
        
        [ptmv.buyBtn addTarget:self
                        action:@selector(buyBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    ptmv.title.text = self.pdm.taokeTitle;
    ptmv.price.text = [NSString stringWithFormat:@"￥%@",self.pdm.taokePrice];
    
    [self updateScrollViewContentSize];
}

-(void)getTaokeItemDetailsByNumiidDidFailed
{
    NSLog(@"====getTaokeItemDetailsByNumiidDidFailed===");
}

-(void)buyBtnAction:(id)sender
{
    
    //友盟统计
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.pdm.pid,@"pid", nil];
    [MobClick event:@"buy_btn" attributes:dict];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&ttid=400000_21125417@txx_iPhone_0.0.0"
                                       , self.pdm.taokeUrl]];
    
    SVWebViewController *webViewController = [[[SVWebViewController alloc] initWithURL:URL
                                                                            thumbImage:nil
                                                                                 title:self.pdm.taokeTitle] autorelease];
    
    [self.navigationController pushViewController:webViewController animated:YES];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mScrollView) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    if (page != _currentPicIdxInAlbumArray) {
        _currentPicIdxInAlbumArray = page;
        
        EGOImageView *image = (EGOImageView *)[scrollView viewWithTag:99+_currentPicIdxInAlbumArray];
        
        if (!image){
            
            image = [[[EGOImageView alloc] initWithFrame:CGRectMake(_currentPicIdxInAlbumArray
                                                                    *self.picScrollView.frame.size.width+20
                                                                                      , 20
                                                                                      , self.picScrollView.frame.size.width-40
                                                                                      , self.picScrollView.frame.size.height-40)]
                                       autorelease];
            image.tag = 99+_currentPicIdxInAlbumArray;
            image.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.picScrollView addSubview:image];
        }   
        
        NSArray *picArray = [self.albumPaginationDict objectForKey:[NSNumber numberWithInt:_currentPicIdxInAlbumArray/_pageSize]];
        
        if (!picArray) {
            //TODO:通过网络获取对应页数据
            
            self.picDetailAlbumPaginationInterface = [[[PicDetailAlbumPaginationInterface alloc] init] autorelease];
            self.picDetailAlbumPaginationInterface.delegate = self;
            [self.picDetailAlbumPaginationInterface getPicDetailAlbumByPageNum:_currentPicIdxInAlbumArray/_pageSize
                                                                    andAlbumId:self.pdm.albumId];
        }
        
//        for (NSInteger i =0; i<3; i++) {
        
        //删除淘客信息
        PicDetailTaokeMsgView *ptmv = (PicDetailTaokeMsgView *)[self.mScrollView viewWithTag:99999];
        [ptmv removeFromSuperview];
        
        if (_currentPicIdxInAlbumArray % _pageSize < picArray.count) {
            PicDetailModel *pdmTmp = [picArray objectAtIndex:_currentPicIdxInAlbumArray % _pageSize];
            
            pdmTmp.albumId = self.pdm.albumId;
            pdmTmp.ownerAlbum = self.pdm.ownerAlbum;
            pdmTmp.cateId = self.pdm.cateId;
            pdmTmp.rootCateId = self.pdm.rootCateId;
            
            self.pdm = pdmTmp;
            
            self.descriptionLabel.text = self.pdm.descTitle;
            
            
            image.imageURL = [NSURL URLWithString:pdmTmp.picUrl];
            
            
            if ([self.pdm.taokeUrl hasPrefix:@"http"]) {
                
                [self getTaokeItemDetailsByNumiidDidFinished:self.pdm.taokeUrl];
                
            }else{
            
                self.taokeItemDetailInterface = [[[TaokeItemDetailInterface alloc] init] autorelease];
                self.taokeItemDetailInterface.delegate = self;
                [self.taokeItemDetailInterface getTaokeItemDetailsByNumiid:self.pdm.taokeNumiid];
            }
        }
        
//        }
        
        
    }
    
}

#pragma mark - PicDetailAlbumPaginationInterfaceDelegate
-(void)getPicDetailAlbumByPageNumDidFinished:(NSArray *)array pageNum:(NSInteger)pageNum
{
    [self.albumPaginationDict setObject:array
                                 forKey:[NSNumber numberWithInt:pageNum]];
    
    _currentPicIdxInAlbumArray = 0;
    [self scrollViewDidScroll:self.picScrollView];
}

-(void)getPicDetailAlbumByPageNumDidFailed:(NSString *)errorMsg pageNum:(NSInteger)pageNum
{
    NSLog(@"---getPicDetailAlbumByPageNumDidFailed--%@",errorMsg);
}



@end
