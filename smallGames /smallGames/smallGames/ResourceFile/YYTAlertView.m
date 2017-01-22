//
//  YYTAlertView.m
//  MortalGames
//
//  Created by kobe on 2017/1/2.
//  Copyright © 2017年 kobe. All rights reserved.
//

#import "YYTAlertView.h"
#import "UIView+Extension.h"
#import "UILabel+LXAdd.h"
#import "Masonry.h"
@interface YYTAlertView ()

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, assign) NSUInteger checkpoint;

@property (nonatomic, assign) BOOL theGamesOver;

@end
@implementation YYTAlertView

-(NSMutableArray*)titles{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithObjects:
                    @"上天恩泽，赐此降福卷",
                    @"马革裹尸，浴血归来，对不起，你挡住本将军的路了！",
                    @"此路是我开，此树是我栽，要想从此过，嘿嘿~ ~ 你懂得",
                    @"秀才遇到兵，有理说不清，怪你嘴笨咯！！",
                    @"古道西风瘦马，夕阳西下，没瞅见你马爷我正找吃的呢！",
                    @"恭喜你成功闯过第一关，一大波僵尸来袭",nil];
    }
    return _titles;

}
-(NSString *)fetchTitleWithType{
    NSString *title = nil;
    switch (self.type) {
            
        case K_OtherType:{
            title = [self.titles objectAtIndex:5];
            
        }
            break;
        case K_JuanZhouType:
        {
            title = [self.titles objectAtIndex:0];
        
        }
            break;
            case K_ZhangAiWUType:
        {
            switch (self.specificType) {
                case K_TagViewOneType:
                {
                    title = [self.titles objectAtIndex:1];
                
                }
                    break;
                case K_TagViewTwoType:
                {
                    title = [self.titles objectAtIndex:2];
                }
                    break;
                case K_TagViewThreeType:
                {
                    title = [self.titles objectAtIndex:3];
                }
                    break;
                case K_tagViewFourType:
                {
                    title = [self.titles objectAtIndex:4];
                }
                    break;
                default:
                    break;
            }
        
        }
            break;
            
        default:
            break;
    }
    return title;

}
+(instancetype)showFetchAlertViewWithType:(MoveType)type andType:(viewType)moveType andBlcok:(SureButtonClickedBlcok)block aandAdd:(UIView *)view and:(BOOL)end{
    
    return [[self alloc]initWithMoveType:type andType:moveType andBlock:block andView:view and:end];
}


-(instancetype)initWithMoveType:(MoveType)type andType:(viewType)moveType andBlock:(SureButtonClickedBlcok)block andView:(UIView *)view and:(BOOL)end{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = view.frame;
        self.type = type;
        self.specificType = moveType;
        self.sureBlock = block;
        self.theGamesOver = end;
        [view addSubview:self];
        
    }
    return self;
}
-(void)show{
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(20,-150, K_UISCREEN_WIDTH-40, 150)];
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.tag = 100;
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 5.0f;
    centerView.center = self.center;
    centerView.alpha = 0;
    [self addSubview:centerView];
    
    //确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((centerView.width-120)/2 , 110, 120, 30);
    button.titleLabel.font = [UIFont fontWithName:@"DFPShaoNvW5" size:14.5f];
    [button setTitle:@"自甘受罚" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 15;
    [button setBackgroundColor:[UIColor yellowColor]];
    [button addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:button];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [self fetchTitleWithType];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:@"DFPShaoNvW5" size:14.5];
    titleLabel.characterSpace = 3;
    titleLabel.lineSpace = 3;
    
    CGRect rect = [titleLabel getLableHeightWithMaxWidth:180];
    titleLabel.frame = CGRectMake((centerView.width-180)/2, 10, rect.size.width, 80);
    [centerView addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    imageView.image = [UIImage imageNamed:@"juan"];
    [centerView addSubview:imageView];
    
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@20);
        make.width.mas_equalTo([UIImage imageNamed:@"juan"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"juan"].size.height);
    }];

    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rect.size.height);
        make.left.mas_equalTo(imageView.mas_right).offset(7);
        
        make.right.mas_equalTo(centerView.mas_right).offset(-20);
        make.top.mas_equalTo(centerView.mas_top).offset(20);
    }];
    
    
    
    

    //----------------
    

    //动画前准备
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];

    } completion:^(BOOL finished) {
        centerView.alpha = 1;
        CGRect frame = centerView.frame;
        centerView.frame = CGRectOffset(frame, 0, -centerView.center.y);
        
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:0 animations:^{
            centerView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)sureButtonClicked:(UIButton *)sender{
    
    UIView *backgroundView = (UIView *)[self viewWithTag:100];
    
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.frame = CGRectOffset(backgroundView.frame, 0, -300);
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        //回调  如果是捡到卷轴则是下一关的过渡
        
        if (self.type == K_JuanZhouType) {
            
            //取值
            NSUInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:@"life"];
            ++count;
            [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"life"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.sureBlock(count);
            
        }else if (self.type == K_ZhangAiWUType){
            self.sureBlock(0);
        }else if(self.type == K_OtherType){
            self.sureBlock(2);
        }
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
