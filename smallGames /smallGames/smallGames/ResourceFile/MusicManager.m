//
//  MusicManage.m
//  Games
//
//  Created by kobe on 2016/11/21.
//  Copyright © 2016年 kobe. All rights reserved.
//

#import "MusicManager.h"

static MusicManager *manager = nil;

@implementation MusicManager

- (instancetype)init
{
    if (self = [super init]) {
        _musicPlayer = [[AVPlayer alloc] init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    }
    return self;
}

//实例化音乐播放器单列对象
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MusicManager alloc]init];
    });
    return manager;
}

- (void)replaceItemWithUrlString:(NSURL *)url andRepeat:(BOOL)repeat
{
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [self.musicPlayer replaceCurrentItemWithPlayerItem:item];
    [self playerPlay];

}
- (void)runLoopTheMovie:(NSNotification *)n{
    
    //注册的通知  可以自动把 AVPlayerItem 对象传过来，只要接收一下就OK
    AVPlayerItem * p = [n object];
    //关键代码
    [p seekToTime:kCMTimeZero];
    
    [_musicPlayer play];
    NSLog(@"重播");
}
// 播放
- (void)playerPlay
{
    [_musicPlayer play];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

}


@end
