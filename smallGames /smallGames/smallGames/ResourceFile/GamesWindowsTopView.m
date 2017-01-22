//
//  GamesWindowsTopView.m
//  MortalGames
//
//  Created by kobe on 2016/12/30.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import "GamesWindowsTopView.h"
#import "UIView+Extension.h"
@interface GamesWindowsTopView ()
{
    UIView *progressV;
//    UIProgressView *progressV1;
}

@property (weak, nonatomic) IBOutlet UIImageView *zoomImageView;

//@property (nonatomic, assign) NSUInteger count;

@end
@implementation GamesWindowsTopView
-(void)drawRect:(CGRect)rect{
    

    
    self.value.progressValue = self.value.frame.size.width;
    
    NSLog(@"----   %f",self.value.width);
    
    
    self.value.trackTintColor = [UIColor redColor];
    self.value.progressTintColor = [UIColor clearColor];
    


}
-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, K_UISCREEN_WIDTH, 90);
    
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
    
    CGFloat count = [[[noti userInfo] objectForKey:@"key"] floatValue];
    
    NSLog(@"通知传过来的血条值:%ld",(unsigned long)count);
    _value.progressValue = count;

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
