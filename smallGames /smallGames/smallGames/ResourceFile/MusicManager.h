//
//  MusicManage.h
//  Games
//
//  Created by kobe on 2016/11/21.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
@interface MusicManager : NSObject

//定义单列对象
@property (nonatomic, strong) AVPlayer *musicPlayer;

//创建单列对象
+(instancetype)manager;


//获取资源
- (void)replaceItemWithUrlString:(NSURL *)url andRepeat:(BOOL)repeat;

//播放
-(void)playerPlay;
@end
