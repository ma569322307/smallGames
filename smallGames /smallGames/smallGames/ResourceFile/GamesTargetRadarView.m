//
//  GamesTargetRadarView.m
//  MortalGames
//
//  Created by kobe on 2016/12/30.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import "GamesTargetRadarView.h"


@interface GamesTargetRadarView ()

@property (nonatomic,weak)CALayer *animationLayer;


@end
@implementation GamesTargetRadarView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
//        当重后台进入前台，防止假死状态
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resume) name:@"PulsingRadarView_animation" object:nil];
        self.backgroundColor = [UIColor clearColor];

    }
    return self;

}
-(void)resume
{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}

-(void)didMoveToWindow{
    [super didMoveToWindow];
    if (self.window !=nil) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 1;
        }];
    }

}
-(void)drawRect:(CGRect)rect
{
    [[UIColor clearColor]setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 3;
    double animationDuration = 2;
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc]init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.backgroundColor = [UIColor yellowColor].CGColor;
        pulsingLayer.borderColor = [UIColor colorWithRed:92.0/255.0 green:181.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = rect.size.height/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.2];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    self.animationLayer.zPosition = -1;//重新加载时，使动画至底层
    [self.layer addSublayer:self.animationLayer];
    
    CALayer * thumbnailLayer = [[CALayer alloc]init];
    thumbnailLayer.backgroundColor = [UIColor whiteColor].CGColor;
    CGRect thumbnailRect = CGRectMake(0, 0, 30, 30);
    thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
    thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
    thumbnailLayer.frame = thumbnailRect;
    thumbnailLayer.cornerRadius = 15.0;
    thumbnailLayer.borderWidth = 1.0;
    thumbnailLayer.masksToBounds = YES;
    thumbnailLayer.borderColor = [UIColor whiteColor].CGColor;
    UIImage * thumbnail = [UIImage imageNamed:@"logo"];
    thumbnailLayer.contents = (id)thumbnail.CGImage;
    thumbnailLayer.zPosition = -1;
    [self.layer addSublayer:thumbnailLayer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
