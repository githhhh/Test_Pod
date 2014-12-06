//
//  ViewController.m
//  Test_Pod
//
//  Created by admin on 14/12/6.
//  Copyright (c) 2014年 com.yongche. All rights reserved.
//

#import "ViewController.h"
#import "NIAttributedLabel+YCNIAttributedLabel.h"
@interface ViewController ()<NIAttributedLabelDelegate>
@property (strong, nonatomic)  NIAttributedLabel *niLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *text = @"阿司法局的；老卡机是；电缆附件；了解到设计费；辣椒水的；路附近阿里斯顿；父类；阿斯蒂芬；阿斯顿；啊；水电费；阿斯顿；飞；啊啊；水电费；暗示；地方；阿里的说法；；阿斯蒂芬李快乐是快递费；发送到；飞";

    
    _niLable = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];//textSize.height+5*6 + img.size.height *3
    [_niLable setFrame: CGRectMake(63, 73, 195, 450)];

    _niLable.backgroundColor = [UIColor yellowColor];
    _niLable.numberOfLines = 0;
    _niLable.delegate = self;

    _niLable.text = text;
    
    
    //图片
    UIEdgeInsets imgMargs = UIEdgeInsetsMake(5, 0, 5, 0);
    UIImage *img = [UIImage imageNamed:@"u2"];
    NSRange rang = [_niLable.text rangeOfString:@"辣椒水的"] ;
    [_niLable insertImage:img
                  atIndex:rang.length +rang.location
                  margins:imgMargs
    verticalTextAlignment:NIVerticalTextAlignmentMiddle
CustomeTriggerImgLinkBlock:^{
    NSLog(@"触发图片链接====11111==");
    
}
];
    
   
    
    
    rang = [_niLable.text rangeOfString:@"啊啊"] ;
    [_niLable insertImage:img
                  atIndex:rang.length +rang.location
    
                  margins:imgMargs
    verticalTextAlignment:NIVerticalTextAlignmentMiddle
CustomeTriggerImgLinkBlock:^{
    NSLog(@"触发图片链接====22222==");
    
}];
    
    

    rang = [_niLable.text rangeOfString:@"阿里的说法"] ;
    [_niLable insertImage:img
                  atIndex:rang.length +rang.location

                  margins:imgMargs
    verticalTextAlignment:NIVerticalTextAlignmentMiddle
CustomeTriggerImgLinkBlock:^{
    NSLog(@"触发图片链接====3333==");
    
}];
    
    
    
    //文字
    [_niLable addLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@(120)]]
                        range: [_niLable.text rangeOfString:@"电缆附件；了解到设计费"]];
    
    [_niLable addLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@(220)]]
                range: [_niLable.text rangeOfString:@"阿斯蒂芬李快乐是快递费"]];
    
    //水电费；暗示；地方
    [_niLable addLink:[NSURL URLWithString:[NSString stringWithFormat:@"%@",@(320)]]
                range: [_niLable.text rangeOfString:@"水电费；暗示；地方"]];
    
    
    _niLable.underlineStyle = kCTUnderlineStyleNone;
    _niLable.linkColor = [UIColor blueColor];
    _niLable.highlightedLinkBackgroundColor = [UIColor clearColor];
    _niLable.linksHaveUnderlines = YES;

    

    [_niLable sizeToFit];
    
    [self.view addSubview:_niLable];

    NSLog(@"====%f",_niLable.frame.size.height);
}


#pragma mark - NIAttributedLabelDelegate
- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point{
    
    NSLog(@"=======%@",result.URL);
    
    
    
    
}





//根据文本获取size ,有最大 宽高限制
-(CGSize)getContentSizeWithContentText:(NSString *)string{
    CGSize size = CGSizeZero;
    if (string) {
        if ([string respondsToSelector:
             @selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            size = [string boundingRectWithSize:CGSizeMake(195, 400)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                                  NSParagraphStyleAttributeName:paragraphStyle}
                                        context:nil].size;
        }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            size = [string sizeWithFont:[UIFont systemFontOfSize:14.0f]
                      constrainedToSize:CGSizeMake(195, 400)
                          lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
        }
    }
    return size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
