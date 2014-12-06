//
//  NIAttributedLabel+YCNIAttributedLabel.h
//  iWeidao
//
//  Created by admin on 14/12/1.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

/**
 *  目前支持NimbusKit-AttributedLabel (1.0.0)
 *  有一定风险，如果被用到的NIAttributedLabel 原始方法名字变化，项目又重新更新了库，则没有效果。
 *
 *
 *  新增功能：
 *
 *  1,检测是否触发链接
 *
 *  2,检测是否触发图片链接(原库中包含添加图文混排的方法，但如果没有链接文本，NIAttributedLabel 将会关闭用户交互)
 *
 *  3,判断NIAttributedLabel  是否包含图片
 *
 *  4,插入的图片支持图片链接，且可自定义触发图片链接的回调block
 *
 *  5,支持图片链接、文字链接 混用且数量不限，可以准确定位触发源并自定义block 回调处理
 *
 *  @param YCNIAttributedLabel YCNIAttributedLabel description
 *
 *  @return return value description
 */
#import "NIAttributedLabel.h"
typedef void(^TriggerImgLinkBlock) (void);

@interface NIAttributedLabel (YCNIAttributedLabel)

/**
 *  检测是否触发NIAttributedLabel 中的链接
 *
 *  @param point in NIAttributedLabel
 *
 *  @return BOOL
 */
-(BOOL)isTriggerLink:(CGPoint )point;

/**
 *  是否触发图片链接
 *
 *  @param point  point description
 *
 *  @return return value description
 */
-(BOOL)isTriggerImgLink:(CGPoint)point ;

/*
 *  检测是否包含图片
 */
-(BOOL)isContaintImgInNIAttributedLabel;



/**
 *  插入图片 在NIAttributedLabel
 *
 *  @param image                     图片
 *  @param index                     插入位置
 *  @param customTriggerImgLinkBlock 触发图片链接block
 */
- (void)insertImage:(UIImage *)image
            atIndex:(NSInteger)index
CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock;


/**
 *  插入图片 在NIAttributedLabel
 *
 *  @param image                     图片
 *  @param index                     插入位置
 *  @param margins                   图片四个边框距离
 *  @param customTriggerImgLinkBlock 触发图片链接block
 */
- (void)insertImage:(UIImage *)image
            atIndex:(NSInteger)index
            margins:(UIEdgeInsets)margins
CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock;

/**
 *  插入图片 在NIAttributedLabel
 *
 *  @param image                     图片
 *  @param index                     插入位置
 *  @param margins                   图片四个边框距离
 *  @param verticalTextAlignment     排列方式
 *  @param customTriggerImgLinkBlock 触发图片链接block
 */
- (void)insertImage:(UIImage *)image
            atIndex:(NSInteger)index
            margins:(UIEdgeInsets)margins
verticalTextAlignment:(NIVerticalTextAlignment)verticalTextAlignment
CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock;


@end
