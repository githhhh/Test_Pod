//
//  NIAttributedLabel+YCNIAttributedLabel.m
//  iWeidao
//
//  Created by admin on 14/12/1.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import "NIAttributedLabel+YCNIAttributedLabel.h"
#import <objc/runtime.h>
#import "NSObject+YCSwizzle.h"
@implementation NIAttributedLabel (YCNIAttributedLabel)
/**
 *  检测是否触发文字链接
 *
 *  @param point point description
 *
 *  @return return value description
 */
-(BOOL)isTriggerLink:(CGPoint )point{
    NSTextCheckingResult *textCheckingResult = [self swizzleLinkAtPoint:point];
    if (nil != textCheckingResult) {
        if ([self swizzleIsPoint:point nearLink:textCheckingResult]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  检测是否触发图片链接
 *
 *  @param point point description
 *
 *  @return return value description
 */
-(BOOL)isTriggerImgLink:(CGPoint)point{
  return [self isTriggerImgLink:point isDetect:YES];
}

/**
 *  检测是否包含图片
 *
 *  @return return value description
 */
-(BOOL)isContaintImgInNIAttributedLabel{
    if ([self swizzleImages]&& [self swizzleImages].count>0) {
        return YES;
    }
    return NO;
}
//插入图片
-(void)insertImage:(UIImage *)image atIndex:(NSInteger)index CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock{
   [self insertImage:image atIndex:index margins:UIEdgeInsetsZero verticalTextAlignment:NIVerticalTextAlignmentBottom CustomeTriggerImgLinkBlock:customTriggerImgLinkBlock];
}
//插入图片
-(void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock{
    [self insertImage:image atIndex:index margins:margins verticalTextAlignment:NIVerticalTextAlignmentBottom CustomeTriggerImgLinkBlock:customTriggerImgLinkBlock];
}

/**
 *  设置图片 在NIAttributedLabel
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
verticalTextAlignment:(NIVerticalTextAlignment)verticalTextAlignment CustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock{
    
    if (nil == [self imgeBlocks]) {
        [self setImgeBlocks:[NSMutableArray array]];
    }
    if (!customTriggerImgLinkBlock) {
        customTriggerImgLinkBlock = ^(void){
            
        };
    }
    [[self imgeBlocks] addObject:[customTriggerImgLinkBlock copy]];
    
    [self swizzleInsertImage:image atIndex:index margins:margins verticalTextAlignment:verticalTextAlignment];
}

#pragma getter/setter
- (NSMutableArray *)imgeBlocks {
    return objc_getAssociatedObject(self, @selector(imgeBlocks));
}
- (void)setImgeBlocks:(NSMutableArray *)value {
    objc_setAssociatedObject(self, @selector(imgeBlocks), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setCustomeTriggerImgLinkBlock:(TriggerImgLinkBlock)customTriggerImgLinkBlock{
    objc_setAssociatedObject(self, nil, customTriggerImgLinkBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark load

+(void)load{
    [self swizzleInstanceSelector:@selector(linkAtPoint:) withNewSelector:@selector(swizzleLinkAtPoint:)];
    [self swizzleInstanceSelector:@selector(isPoint:nearLink:) withNewSelector:@selector(swizzleIsPoint:nearLink:)];
    
    [self swizzleInstanceSelector:@selector(images) withNewSelector:@selector(swizzleImages)];
    [self swizzleInstanceSelector:@selector(textFrame) withNewSelector:@selector(swizzleTextFrame)];
    [self swizzleInstanceSelector:@selector(numberOfDisplayedLines) withNewSelector:@selector(swizzleNumberOfDisplayedLines)];
    
    [self swizzleInstanceSelector:@selector(touchesEnded:withEvent:) withNewSelector:@selector(swizzleTouchesEnded:withEvent:)];
    
    [self swizzleInstanceSelector:@selector(drawTextInRect:) withNewSelector:@selector(swizzleDrawTextInRect:)];
    
    [self swizzleInstanceSelector:@selector(verticalTextAlignment) withNewSelector:@selector(swizzleVerticalTextAlignment)];
    

    [self swizzleInstanceSelector:@selector(insertImage:atIndex:margins:verticalTextAlignment:) withNewSelector:@selector(swizzleInsertImage:atIndex:margins:verticalTextAlignment:)];
    
    [self swizzleInstanceSelector:@selector(longPressTimer) withNewSelector:@selector(swizzleLongPressTimer)];
    
}



#pragma  private Methode
/**
 *  是否触发图片链接
 *
 *  @param point  point description
 *  @param detect 检测或调用
 *
 *  @return return value description
 */

-(BOOL)isTriggerImgLink:(CGPoint)point isDetect:(BOOL)detectOrCall{
    __block BOOL resulte ;
    
    if ([self swizzleImages]&&[self swizzleImages].count>0) {
        NSMutableArray *imgRectArr = [self imgRectInNIAttributedLabel];
        [imgRectArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGRect imgRect = [imgRectArr[idx] CGRectValue];
            if (CGRectEqualToRect(imgRect, CGRectZero)) {
                resulte = NO;
                return;
            }
            resulte = CGRectContainsPoint(imgRect, point);
            if (resulte) {
                if (!detectOrCall) {
                    TriggerImgLinkBlock imgLinkBlock = [[self imgeBlocks]
                                                        objectAtIndex:idx];
                    [self setCustomeTriggerImgLinkBlock:imgLinkBlock];
                }
                *stop = YES;
            }
        }];
    }
    return resulte;
}

-(NSMutableArray *)imgRectInNIAttributedLabel{
    NSMutableArray *imgRectArrInNiLable = [NSMutableArray arrayWithCapacity:0];

    if (0 == [self swizzleImages].count) {
        return imgRectArrInNiLable;
    }
    CFArrayRef lines = CTFrameGetLines([self swizzleTextFrame]);
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins([self swizzleTextFrame], CFRangeMake(0, 0), lineOrigins);
    NSInteger numberOfLines = [self swizzleNumberOfDisplayedLines];

    for (CFIndex i = 0; i < numberOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CGPoint lineOrigin = lineOrigins[i];
        CGFloat lineAscent;
        CGFloat lineDescent;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
        CGFloat lineHeight = lineAscent + lineDescent;
        CGFloat lineBottomY = lineOrigin.y - lineDescent;
        
        for (CFIndex k = 0; k < runCount; k++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(__bridge id)kCTRunDelegateAttributeName];
            if (nil == delegate) {
                continue;
            }
            //无法取到NIAttributedLabelImage ,这里用id 类型，让运行时去判断去。
            
            __typeof__([[self swizzleImages] objectAtIndex:0])  labelImage =  (__bridge __typeof__([[self swizzleImages] objectAtIndex:0]) )CTRunDelegateGetRefCon(delegate);
            CGFloat ascent = 0.0f;
            CGFloat descent = 0.0f;
            CGFloat width = (CGFloat)CTRunGetTypographicBounds(run,
                                                               CFRangeMake(0, 0),
                                                               &ascent,
                                                               &descent,
                                                               NULL);
            
            
            SEL szSelector = NSSelectorFromString(@"boxSize");
            CGSize szBoxSize;
            if (szSelector&&[labelImage respondsToSelector:szSelector]) {
                NSInvocation *boxSizeInvocation = [NSInvocation  invocationWithMethodSignature:[labelImage methodSignatureForSelector:szSelector]];
                [boxSizeInvocation setTarget:labelImage];
                [boxSizeInvocation setSelector:szSelector];
                [boxSizeInvocation invoke];
                [boxSizeInvocation getReturnValue:&szBoxSize];
            }else {
                return imgRectArrInNiLable;
            }
            
            CGFloat imageBoxHeight = szBoxSize.height;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
            
            CGFloat imageBoxOriginY = 0.0f;
            
            switch ([self swizzleVerticalTextAlignment]) {
                case NIVerticalTextAlignmentTop:
                    imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight);
                    break;
                case NIVerticalTextAlignmentMiddle:
                    imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight) / 2.0;
                    break;
                case NIVerticalTextAlignmentBottom:
                    imageBoxOriginY = lineBottomY;
                    break;
            }
            CGRect rect = CGRectMake(lineOrigin.x + xOffset, (self.frame.size.height - imageBoxOriginY)-lineHeight, width, imageBoxHeight);
            
            SEL mgSelector = NSSelectorFromString(@"margins");
            UIEdgeInsets flippedMargins;
            if (mgSelector && [labelImage respondsToSelector:mgSelector]) {
                NSInvocation *marginsInvocation = [NSInvocation invocationWithMethodSignature:[labelImage methodSignatureForSelector:mgSelector]];
                [marginsInvocation setTarget:labelImage];
                [marginsInvocation setSelector:mgSelector];
                [marginsInvocation invoke];
                [marginsInvocation getReturnValue:&flippedMargins];
            }else {
                return imgRectArrInNiLable;
            }
            
            CGFloat top = flippedMargins.top;
            flippedMargins.top = flippedMargins.bottom;
            flippedMargins.bottom = top;
            
            CGRect imageRect = UIEdgeInsetsInsetRect(rect, flippedMargins);
            [imgRectArrInNiLable addObject:[NSValue valueWithCGRect:imageRect]];
        }
    }
    return imgRectArrInNiLable;
}



#pragma mark -  swizzle origine Methode with customMethode

-(void)swizzleInsertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins verticalTextAlignment:(NIVerticalTextAlignment)verticalTextAlignment{
    [self swizzleInsertImage:image atIndex:index margins:margins verticalTextAlignment:verticalTextAlignment];
}


-(NIVerticalTextAlignment)swizzleVerticalTextAlignment{
    return  [self swizzleVerticalTextAlignment];
}
-(void)swizzleDrawTextInRect:(CGRect)rect{
    [self swizzleDrawTextInRect:rect];
    if (!self.userInteractionEnabled)
    self.userInteractionEnabled = YES;
}
-(NSTextCheckingResult *)swizzleLinkAtPoint:(CGPoint)point{
    return  [self swizzleLinkAtPoint:point];
}
-(BOOL)swizzleIsPoint:(CGPoint)point nearLink:(NSTextCheckingResult *)link{
    BOOL resulte = [self swizzleIsPoint:point nearLink:link];
    return resulte;
}
-(NSMutableArray *)swizzleImages{
    NSMutableArray *imgArr = [self swizzleImages];
    return imgArr;
}

-(CTFrameRef)swizzleTextFrame{
    CTFrameRef sTextFrame  = [self swizzleTextFrame];
    return sTextFrame;
}
-(NSInteger)swizzleNumberOfDisplayedLines{
   NSInteger swizzleNum = [self swizzleNumberOfDisplayedLines];
    return swizzleNum;
}


-(void)swizzle_longPressTimerDidFire:(NSTimer *)timer {
    
}

-(NSTimer *)swizzleLongPressTimer{
   return [self swizzleLongPressTimer];
}


/**检测图片链接*************/
-(void)swizzleTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //关闭长按手势
    NSTimer *longTimer =[self swizzleLongPressTimer];
    if (longTimer) {
        [longTimer invalidate];
    }
    if ([self swizzleImages]&&[self swizzleImages].count >0) {
        //
        UITouch* touch1 = [touches anyObject];
        CGPoint point1 = [touch1 locationInView:self];
        BOOL isTrigger =  [self isTriggerImgLink:point1 isDetect:NO];
        if (isTrigger) {
            //回调....
            TriggerImgLinkBlock triggerLB = objc_getAssociatedObject(self, nil);
            if (triggerLB) {
                triggerLB();
                return;
            }
        }
    }
    [self swizzleTouchesEnded:touches withEvent:event];
    
}

@end
