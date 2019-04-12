//
//  CZToast.h
//  CZToast
//
//  Created by yunshan on 2019/4/12.
//  Copyright © 2019 ChenZhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 @brief Toast回调事件
 */
typedef void(^ToastCallback) (BOOL success, NSError * __nullable error, NSDictionary * __nullable dic);


/**
 @brief Toast显示策略
 */
typedef NS_ENUM(NSInteger, CZToastShowType) {
    /** 立即消失(默认) */
    CZToastShowTypeImmediately = 1,
    /** 依次显示 */
    CZToastShowTypeQueue
};

/**
 @brief Toast组件(目前仅支持文本，后续加入显示自定义图片)
 */
@interface CZToast : UIView
#pragma mark 属性
/**
 @brief 显示策略 (默认依次显示)
 @see CZToastShowType
 */
@property (nonatomic, assign) CZToastShowType showType;
/**
 @brief 显示时间间隔 (默认1.5秒)
 */
@property (nonatomic, assign) CGFloat during;

/**
 @brief 获取Toast实例
 @discussion [CZToast shareManager]
 */
+(instancetype)shareManager;

#pragma mark 显示在中间
/**
 @brief 屏幕中心显示Toast
 
 @param text 显示文本
 */
-(void)showInCenter:(NSString *)text;

/**
 @brief 屏幕中心显示Toast，且有回调信息

 @param text 显示文本
 @param callback 事件回调
 @discussion (暂先不支持)
 */
-(void)showInCenter:(NSString *)text callback:(ToastCallback)callback;

#pragma mark 显示在底部
/**
 @brief 屏幕底部显示Toast
 
 @param text 显示文本
 */
-(void)showInBottom:(NSString *)text;

/**
 @brief 屏幕底部显示Toast，且有回调信息
 
 @param text 显示文本
 @param callback 事件回调
 @discussion (暂先不支持)
 */
-(void)showInBottom:(NSString *)text callback:(ToastCallback)callback;

#pragma mark 显示在顶部
/**
 @brief 屏幕顶部显示Toast
 
 @param text 显示文本
 */
-(void)showInTop:(NSString *)text;


/**
 @brief 屏幕顶部显示Toast，且有回调信息
 
 @param text 显示文本
 @param callback 事件回调
 @discussion (暂先不支持)
 */
-(void)showInTop:(NSString *)text callback:(ToastCallback)callback;
@end

NS_ASSUME_NONNULL_END
