//
//  NIAttributedLabel+YCNIAttributedLabel.h
//  iWeidao
//
//  Created by githhhh on 14/12/1.
//  Copyright (c) 2014年 githhhh. All rights reserved.
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
 *  @param XYNIAttributedLabel XYNIAttributedLabel description
 *
 *  @return return value description
 */
