//
//  YYTAlertView.h
//  MortalGames
//
//  Created by kobe on 2017/1/2.
//  Copyright © 2017年 kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureButtonClickedBlcok) (NSUInteger checkPoint);

typedef enum : NSUInteger {
    K_JuanZhouType,    //碰到了卷轴
    K_ZhangAiWUType,   //碰到了障碍物
    K_OtherType        //其他的。。。。
} MoveType;



typedef enum :NSUInteger{
    K_TagViewOneType,  //如果是障碍物的话，是什么东西   将军
    K_TagViewTwoType,  //                          强盗
    K_TagViewThreeType,//                          士兵
    K_tagViewFourType  //                          马匹
    
}viewType;


@interface YYTAlertView : UIView

@property (nonatomic, assign) MoveType type;
@property (nonatomic, assign) viewType specificType;

@property (nonatomic, copy) SureButtonClickedBlcok sureBlock;


//弹出只有一个按钮的弹窗
+(instancetype)showFetchAlertViewWithType:(MoveType)type andType:(viewType)moveType andBlcok:(SureButtonClickedBlcok)block aandAdd:(UIView *)view and:(BOOL)end;

//展示
-(void)show;

@end
