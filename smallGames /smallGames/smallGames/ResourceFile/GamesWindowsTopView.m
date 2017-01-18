//
//  GamesWindowsTopView.m
//  MortalGames
//
//  Created by kobe on 2016/12/30.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import "GamesWindowsTopView.h"
#import "YSProgressView.h"
#import "UIView+Extension.h"
@interface GamesWindowsTopView ()
{
    UIView *progressV;
    UIProgressView *progressV1;
}
//生命条
@property (weak, nonatomic) IBOutlet YSProgressView *value;

@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;

//@property (nonatomic, assign) NSUInteger count;

@end
@implementation GamesWindowsTopView
-(void)drawRect:(CGRect)rect{
    self.value.progressValue = 20;
    self.value.trackTintColor = [UIColor redColor];
    self.value.progressTintColor = [UIColor clearColor];
    


}
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.zoomImageView addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchOtherMoveCrash:) name:@"K_LLIFEVALUE" object:nil];

}
+(instancetype)createGamesTopViewInstance{
    GamesWindowsTopView *topView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GamesWindowsTopView class]) owner:self options:0] lastObject];
    return topView;
}
-(void)tap:(UITapGestureRecognizer *)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backgroundstate" object:nil];

}
-(void)fetchOtherMoveCrash:(NSNotification *)noti{
    NSUInteger count = [[[noti userInfo] objectForKey:@"key"] integerValue];
    // 系统progress
    [progressV1 setProgress:count animated:YES];
    // 未封装 progressview
//    int maxValue = 280;
    // 变量
    CGFloat tempValue = (CGFloat)count;
    
    CGFloat progressWidth = tempValue;
    
    double durationValue = (tempValue/2.0) / (tempValue * 10.0f) + .5 ;
    
    [UIView animateWithDuration:durationValue animations:^{
        
        progressV.width = progressWidth;
    }];
    // YSProgressView
    _value.progressValue = progressWidth;

}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"K_LLIFEVALUE" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
