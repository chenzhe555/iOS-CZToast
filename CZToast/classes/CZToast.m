//
//  CZToast.m
//  CZToast
//
//  Created by yunshan on 2019/4/12.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import "CZToast.h"
#import <CZCategorys/UIView+CZCategory.h>
#import <CZCategorys/NSString+CZCategory.h>
#import <CZCategorys/NSObject+CZCategory.h>
#import <CZConfig/CZConfig.h>


/**
 Toast显示位置
 */
typedef NS_ENUM(NSInteger, CZToastLocation) {
    /** 显示在中间 */
    CZToastLocationCenter = 1,
    /** 显示在顶部 */
    CZToastLocationTop,
    /** 显示在底部 */
    CZToastLocationBottom
};

@interface CZToast ()
/**
 @brief Toast显示信息字典
 */
@property (nonatomic, strong) NSMutableArray * toastArray;
/**
 @brief 定时器
 */
@property (nonatomic, strong) NSTimer * showTimer;
/**
 @brief 文本视图
 */
@property (nonatomic, strong) UILabel * textLabel;
/**
 @brief 左右间隙
 */
@property (nonatomic, assign) CGFloat lrSpace;
/**
 @brief 顶底间隙
 */
@property (nonatomic, assign) CGFloat tbSpace;
/**
 @brief 两边的间隙
 */
@property (nonatomic, assign) CGFloat contentSpace;
/**
 @brief 正在显示Toast
 */
@property (nonatomic, assign) BOOL isShowingToast;
/**
 @brief Tabbar高度
 */
@property (nonatomic, assign) CGFloat tabbarHeight;
/**
 @brief TopBar高度
 */
@property (nonatomic, assign) CGFloat topBarHeight;
@end

@implementation CZToast


/**
 @brief 获取当前实例
 */
+(instancetype)shareManager
{
    static CZToast * toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[CZToast alloc] init];
        UIWindow * window = [self getMainWindow];
        toast.frame = CGRectZero;
        [window addSubview:toast];
        toast.hidden = YES;
    });
    return toast;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColor(0, 0, 0, 0.3);
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.toastArray = [NSMutableArray array];
        self.lrSpace = 20;
        self.tbSpace = 10;
        self.contentSpace = 30;
        self.during = 1.5;
        self.isShowingToast = NO;
        self.showType = CZToastShowTypeQueue;
        self.topBarHeight = kTopBarHeight;
        self.tabbarHeight = kTabbarHeight;
    }
    return self;
}

-(void)showInCenter:(NSString *)text
{
    [self showToast:text location:CZToastLocationCenter callback:nil];
}

-(void)showInCenter:(NSString *)text callback:(ToastCallback)callback
{
    [self showToast:text location:CZToastLocationCenter callback:callback];
}

-(void)showInBottom:(NSString *)text
{
    [self showToast:text location:CZToastLocationBottom callback:nil];
}

-(void)showInBottom:(NSString *)text callback:(ToastCallback)callback
{
    [self showToast:text location:CZToastLocationBottom callback:callback];
}

-(void)showInTop:(NSString *)text
{
    [self showToast:text location:CZToastLocationTop callback:nil];
}

-(void)showInTop:(NSString *)text callback:(ToastCallback)callback
{
    [self showToast:text location:CZToastLocationTop callback:callback];
}

-(void)showToast:(NSString *)text location:(NSInteger)location callback:(ToastCallback)callback
{
    if (text.length <= 0) return;
    NSDictionary * dic = @{
                           @"text": text,
                           @"location": @(location),
                           @"callback": callback ? [callback copy] : [NSNull null]
                           };
    [self.toastArray addObject:dic];
    [self updateToastInfo];
}


/**
 @brief 渲染Toast信息
 */
-(void)updateToastInfo
{
    if (self.toastArray.count <= 0) {
        [self hide];
        return;
    }
    
    //如果是立即消失策略的话，停止当前计时器并删除数组前面元素
    if (self.showType == CZToastShowTypeImmediately) {
        [self.showTimer invalidate];
        self.showTimer = nil;
        self.isShowingToast = NO;
        NSDictionary * dic = self.toastArray[self.toastArray.count - 1];
        self.toastArray = [NSMutableArray arrayWithObject:dic];
    }
    
    //获取显示信息
    NSDictionary * dic = self.toastArray[0];
    NSString * text = dic[@"text"];
    NSInteger location = [dic[@"location"] integerValue];
    
    //赋值文本
    self.textLabel.text = text;
    CGSize textSize = [text getTextActualSize:self.textLabel.font lines:0 maxWidth:(SCREENW - self.contentSpace*2)];
    self.textLabel.frame = CGRectMake(self.lrSpace, self.tbSpace, textSize.width, textSize.height);
    //赋值坐标并显示
    CGRect rect = CGRectZero;
    rect.size.width = textSize.width + self.lrSpace*2;
    rect.size.height = textSize.height + self.tbSpace*2;
    rect.origin.x = (SCREENW - rect.size.width)/2;
    switch (location) {
        case CZToastLocationTop:
        {
            rect.origin.y = self.topBarHeight;
        }
            break;
        case CZToastLocationBottom:
        {
            rect.origin.y = SCREENH - self.tabbarHeight - textSize.height;
        }
            break;
        case CZToastLocationCenter:
        {
            rect.origin.y = (SCREENH - rect.size.height)/2;
        }
            break;
            
        default:
            break;
    }
    self.frame = rect;
    self.hidden = NO;
    
    if (!self.isShowingToast) {
        [self start];
    }
}


/**
 @brief 检查是否还有Toast需要弹出
 */
-(void)checkHaveMoreShowToast
{
    self.isShowingToast = NO;
    if (self.toastArray.count <= 0) {
        [self hide];
    } else {
        //执行回调
        ToastCallback callback = self.toastArray[0][@"callback"];
        if (![callback isKindOfClass:[NSNull class]]) {
            callback(YES, nil, nil);
        }
        //移除数组第一个元素
        if (self.toastArray.count > 0) [self.toastArray removeObjectAtIndex:0];
        [self updateToastInfo];
    }
}


/**
 @brief 开始显示
 */
-(void)start
{
    self.isShowingToast = YES;
    self.showTimer = [NSTimer scheduledTimerWithTimeInterval:self.during target:self selector:@selector(checkHaveMoreShowToast) userInfo:nil repeats:NO];
}

/**
 @brief 隐藏当前视图
 */
-(void)hide
{
    [self.showTimer invalidate];
    self.showTimer = nil;
    self.hidden = YES;
}
#pragma mark 属性
-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}
@end
