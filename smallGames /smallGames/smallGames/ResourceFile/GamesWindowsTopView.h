//
//  GamesWindowsTopView.h
//  MortalGames
//
//  Created by kobe on 2016/12/30.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSProgressView.h"

@interface GamesWindowsTopView : UIView

//生命条
@property (weak, nonatomic) IBOutlet YSProgressView *value;

//返回一个实例
+(instancetype)createGamesTopViewInstance;

@end
