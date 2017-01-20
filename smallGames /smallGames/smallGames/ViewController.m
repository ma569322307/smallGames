//
//  ViewController.m
//  smallGames
//
//  Created by kobe on 2017/1/4.
//  Copyright © 2017年 kobe. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "UserStorePointModel.h"
#import "GamesTargetRadarView.h"
#import "YYTAlertView.h"
#import "GamesWindowsTopView.h"
#import "YSProgressView.h"
#import "MusicManager.h"
#define K_stateBarHeight 90

typedef void(^AnimationCompletionBlock) (NSUInteger index);

#define K_ITEMWIDTH (K_UISCREEN_WIDTH-4*padd)/4
#define K_ITEMHEIGHT ((K_UISCREEN_HEIGHT-90)-5*padd)/5
#define padd 30
@interface ViewController ()<UIScrollViewDelegate,CAAnimationDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//获取到最大（移动障碍物活动的范围）背景地图的滚动范围 contentSize
@property (nonatomic,assign) CGSize contentSize;
//记录一下大地图的宽高度
@property (nonatomic,assign) CGSize scrollViewSize;

@property (nonatomic,strong) UIView *playerMoveScopeView;

@property (nonatomic,assign) BOOL scaleBool;

//保存放大之前的 rect 区域
@property (nonatomic,assign) CGRect rect;

@property (nonatomic,copy) AnimationCompletionBlock completion;
//添加一个监听是否碰撞的定时器
@property (nonatomic,strong) CADisplayLink *linkDisplay;
//盛放动画对象
@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic, strong) NSMutableArray *moveArray;
//玩家
@property (nonatomic, strong) UIImageView *player;
//地图缩放布尔值
@property (nonatomic, assign) BOOL scale;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger colum;

@property (nonatomic,strong) NSMutableArray *points;
//卷轴
@property (nonatomic,strong) GamesTargetRadarView *targetView;
//保存一个第一次碰撞上的时间
@property (nonatomic, strong) NSDate *date;


@property (nonatomic,assign) NSUInteger count;

//字体数组
@property (nonatomic, strong) NSMutableArray *titles;

//    缩放之前记住坐标
@property (nonatomic, assign) CGPoint point;
//上面向存放卷轴位置
@property (nonatomic, strong) NSMutableArray *cursesTopBooks;


//下面存放卷轴的位置
@property (nonatomic, strong) NSMutableArray *cursesBottomBooks;

@property (nonatomic, assign) CGRect scaleRect;


//记录关卡数
@property (nonatomic,assign) NSInteger customPassValue;

//第几张卷轴
@property (nonatomic,assign) NSInteger index;

//撞上的是什么
@property (nonatomic,assign) MoveType type;

@end

@implementation ViewController
-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithObjects:@"镖\n局",@"兵\n部",@"船\n家",@"铛\n铺",@"东\n厂",@"赌\n场",
                   @"粉\n巷",@"侯\n府",@"花\n房",@"剑\n庐",@"李\n府",@"柳\n巷",
                   @"罗\n家",@"筝\n房",@"茅\n房",@"梦\n魇",@"庞\n府",@"书\n房",
                   @"寺\n庙",@"苏\n堤",@"唐\n门",@"戏\n台",@"烟\n馆",@"雁\n塔",
                   @"药\n铺",@"乐\n坊",@"杂\n耍", nil];
    }
    return _titles;
}

-(NSMutableArray *)points{
    if (!_points) {
        _points = [[NSMutableArray alloc]init];
    }
    return _points;
}
-(GamesTargetRadarView *)targetView{
    if (!_targetView) {
        
        _targetView = [[GamesTargetRadarView alloc]initWithFrame:CGRectMake((padd + K_ITEMWIDTH) * 3-15, (padd + K_ITEMHEIGHT) *3-15, 200, 200)];
        _targetView.center =CGPointMake(self.scrollViewSize.width +(padd + K_ITEMWIDTH) * 3, self.scrollViewSize.height + (padd + K_ITEMHEIGHT) *3);
        _targetView.center = [self.cursesBottomBooks[arc4random()%3] CGPointValue];
    }
    return _targetView;
}
-(UIImageView *)player{
    
    if (!_player) {
        _player = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollViewSize.width +(padd + K_ITEMWIDTH) * 2-15, self.scrollViewSize.height + (padd + K_ITEMHEIGHT) *3-15, padd, padd)];
        _player.image = [UIImage imageNamed:@"icon"];
        _player.contentMode = UIViewContentModeCenter;
        _player.layer.masksToBounds = YES;
        _player.layer.cornerRadius  = 15;
    }
    return _player;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, K_stateBarHeight, K_UISCREEN_WIDTH, K_UISCREEN_HEIGHT-K_stateBarHeight)];
        _scrollView.contentSize = CGSizeMake(K_UISCREEN_WIDTH*5, (K_UISCREEN_HEIGHT-K_stateBarHeight)*6);
        //记录 scrollView 的宽高度
        _scrollViewSize = CGSizeMake(K_UISCREEN_WIDTH, K_UISCREEN_HEIGHT-K_stateBarHeight);
        //记录 scrollview 可滚动的范围
        _contentSize = _scrollView.contentSize;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentOffset = CGPointMake(K_UISCREEN_WIDTH+(padd+K_ITEMWIDTH)/2, _scrollViewSize.height+(padd+K_ITEMHEIGHT)/2);
        
        _scrollView.minimumZoomScale = (K_UISCREEN_HEIGHT-90)/_contentSize.height;
        _scrollView.maximumZoomScale = _contentSize.height/(K_UISCREEN_HEIGHT-90);
        
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

-(void)topView{
    GamesWindowsTopView *view = [GamesWindowsTopView createGamesTopViewInstance];
    view.frame = CGRectMake(0, 0, K_UISCREEN_WIDTH, 90);
    [self.view addSubview:view];
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(state:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    _count = 280;
}
-(void)state:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        _scaleRect = self.scrollView.bounds;
        
        [self.scrollView zoomToRect:CGRectMake(0, 0, _contentSize.width, _contentSize.height) animated:YES];
        
    }else{
        
        [self.scrollView zoomToRect:_scaleRect animated:YES];
    }
    

}
-(NSMutableArray *)animations{
    if (!_animations) {
        _animations = [[NSMutableArray alloc]init];
    }
    return _animations;
}

-(void)buttonScaleClicked{
        _scaleBool = !_scaleBool;
        if (_scaleBool) {
            // 首先暂停动画
            [self pauseLayer];

            //记住放大之前，缩小时的 rect
            _point = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y); //记住放大之前的偏移量是多少。还要缩回来
            CGRect rect = [self zoomRectScale:self.player.center andBOOL:YES];
            

            //记住了，然后放大
            [self.scrollView zoomToRect:rect animated:YES];
            
        }else{
            [self resumeLayer];
            CGRect rect = [self zoomRectScale:self.player.center andBOOL:NO];

            [self.scrollView zoomToRect:rect animated:YES];
        }
}
-(CGRect)zoomRectScale:(CGPoint)center andBOOL:(BOOL)open{
    CGRect rect;
    UIView *view = [self.view viewWithTag:46];
    if (open) {
        //先禁止手势
        view.userInteractionEnabled = NO;
        rect = self.playerMoveScopeView.frame;
    }else{
        //启动手势
        view.userInteractionEnabled = YES;
        rect.size.width = K_UISCREEN_WIDTH;
        rect.size.height = K_UISCREEN_HEIGHT-90;
        rect.origin.x = _point.x;
        rect.origin.y = _point.y;
    
    }
    return rect;
}
-(void)setup{
    
    //默认第一关
    _customPassValue = 1;
    
    _row = 0;
    _colum = 1;
    
    //捡到的卷轴数量
    _index = 0;
    //记录一下当前时间
    _date = [NSDate date];
    
    self.cursesTopBooks = [NSMutableArray arrayWithObjects:
                           [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 2,15 +(padd + K_ITEMHEIGHT) *2)],
                           [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 6, 15 +(padd + K_ITEMHEIGHT) *2)],
                            [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 10,15 +(padd + K_ITEMHEIGHT) *2)],nil];
    self.cursesBottomBooks = [NSMutableArray arrayWithObjects:
                              [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 2, 15 +(padd + K_ITEMHEIGHT) *19)],
                              [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 6,15 +(padd + K_ITEMHEIGHT) *19)],
                              [NSValue valueWithCGPoint:CGPointMake(15 +(padd + K_ITEMWIDTH) * 12,15 +(padd + K_ITEMHEIGHT) *19)], nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //背景音乐的播放
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Emilia Rydberg-Big Big World0001" ofType:@"mp3"]];
        [[MusicManager manager] replaceItemWithUrlString:url andRepeat:YES];
    });
    [self setup];
    [self topView];
    
    
    [self.view addSubview:self.scrollView];
    //放了 scrollView 以后放一层透明的全覆盖 uiview 上去，以便于缩小观察
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentSize.width, _contentSize.height)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.tag = 45;
    [self.scrollView addSubview:maskView];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.playerMoveScopeView.x-100,self.playerMoveScopeView.y-100 , 1190, 2142)];
    image.contentMode = UIViewContentModeScaleToFill;
    image.image = [UIImage imageNamed:@"bg2"];
    [maskView addSubview:image];
    
    
    
    [maskView addSubview:self.playerMoveScopeView];
    [self.playerMoveScopeView addSubview:self.targetView];
    self.moveArray = [[NSMutableArray alloc]init];
    
    //添加动画
    for (int i = 0; i<250; i++) {
        //第一关相关设置
        if (_customPassValue == 1) {
        //如果是第一关的相关设置
        UIImageView *bollimageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%10*(K_ITEMWIDTH+padd)*2-15+K_ITEMWIDTH+padd, i/10*(K_ITEMHEIGHT+padd) *3-15, padd, padd)];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setValue:[NSNumber numberWithInt:i] forKey:@"animationIndex"];
        [self.animations addObject:animation];
        animation.delegate = self;
        
        UserStorePointModel *model = [[UserStorePointModel alloc]init];
        model.row = i%10 *2+1;
        model.colum = 3*i/10;
        [self.points addObject:model];
        
        bollimageView.backgroundColor = [UIColor clearColor];
        [maskView addSubview:bollimageView];
        [self.moveArray addObject:bollimageView];
        
        bollimageView.tag = 100+i;
        if (bollimageView.tag<125) {
            bollimageView.image = [UIImage imageNamed:@"general"];
            animation.speed = ((arc4random()%20)+10)/100.00;
            
        }else if (bollimageView.tag<175){
            bollimageView.image = [UIImage imageNamed:@"hours"];
            animation.speed = ((arc4random()%20)+20)/100.00;
            
        }else if (bollimageView.tag<250){
            bollimageView.image = [UIImage imageNamed:@"qianghdao"];
            animation.speed = ((arc4random()%20)+30)/100.00;
        }else{
            bollimageView.image = [UIImage imageNamed:@"soldier"];
            animation.speed = ((arc4random()%20)+40)/100.00;
        }
        
        animation.speed = ((arc4random()%20)+20)/100.00;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = 0;
        
        dispatch_async(queue, ^{//-------------------------------------异步线程
            __weak __typeof (&*self)weakSelf = self;
            
            __block int value;
            self.completion = ^(NSUInteger index){//-------myblock
                
                __strong __typeof (&*weakSelf)strongSelf = weakSelf;
                
                UIImageView *viewIndex = weakSelf.moveArray[index];
                CABasicAnimation *animation = [weakSelf.animations objectAtIndex:index];
                animation.fromValue = [NSValue valueWithCGPoint:viewIndex.center];
                
            arcOrientation:{
                
                value = arc4random()%4;
                
            }
                //随机出来值以后去拿到相对于最大背景的坐标，以便控制在大范围内不要跑出去
                if (![strongSelf fetchLocationBaseBackground:viewIndex.frame andDirection:value]) {
                    goto arcOrientation;
                }
                //拿到这个球的模型去修改值
                UserStorePointModel *model = [strongSelf.points objectAtIndex:index];
                [strongSelf fetchAllStateMoveViewToChangeValue:animation and:value andView:viewIndex andModel:model];
    
            };//-----------------myblock
        });//------------------------------------------------------------异步线程
        }
    }
    [maskView addSubview:self.player];
    
    //添加每帧定时器来检测是否碰撞了
    self.linkDisplay = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMoveViewFrame)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonScaleClicked) name:@"backgroundstate" object:nil];
    
    NSArray * array = @[@(UISwipeGestureRecognizerDirectionLeft),
                        @(UISwipeGestureRecognizerDirectionRight),
                        @(UISwipeGestureRecognizerDirectionUp),
                        @(UISwipeGestureRecognizerDirectionDown)];
    
    UIView *view = [[UIView alloc]initWithFrame:self.scrollView.frame];
    view.tag = 46;
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    // 定义一个四个方向手势
    UISwipeGestureRecognizer * swipe;
    for (NSNumber * number in array) {
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
        swipe.direction = [number integerValue];
        [view addGestureRecognizer:swipe];
    }
    //这里三秒钟以后呼叫主线程去开始动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.linkDisplay addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        for (int i = 0; i<[self.moveArray count]; i++) {
            self.completion(i);
        }
    });
    
}


#pragma mark----四个手势处理
-(void)tapRecognizer:(UISwipeGestureRecognizer *)sender{
    if (!_scale) {
        CGSize size = self.player.size;
        CGFloat x = self.player.x;
        CGFloat y = self.player.y;
        
        switch (sender.direction) {
            case UISwipeGestureRecognizerDirectionUp://上
            {
                //偏移到的 y 值
                CGFloat lastY = y-(K_ITEMHEIGHT+padd);
                if (_colum<2) {
                    //滑人
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        self.player.frame = CGRectMake(x, lastY,size.width,size.height);
                        
                    } completion:^(BOOL finished) {
                        //增加坐标
                        ++_colum;
                    }];
                }else{
                    //滑地图
                    if (self.scrollView.contentOffset.y > self.scrollViewSize.height-(K_ITEMHEIGHT +padd) *1.5+15) {
                        [UIView animateWithDuration:0.2 animations:^{
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y-(K_ITEMHEIGHT+padd)) animated:NO];
                            self.player.frame = CGRectMake(x, lastY, size.width, size.height);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }
            }
                break;
            case UISwipeGestureRecognizerDirectionLeft://左
            {
                CGFloat lastX = x-K_ITEMWIDTH-padd;
                if (_row>0) {
                    //滑人物
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        self.player.frame = CGRectMake(lastX, y,size.width,size.height);
                    } completion:^(BOOL finished) {
                        //增加坐标
                        --_row;
                    }];
                }else{
                    //滑地图
                    if (self.scrollView.contentOffset.x > self.scrollViewSize.width-(K_ITEMWIDTH +padd)) {
                        [UIView animateWithDuration:0.2 animations:^{
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x-(K_ITEMWIDTH +padd), self.scrollView.contentOffset.y) animated:NO];
                            self.player.frame = CGRectMake(lastX, y, size.width, size.height);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }
            }
                break;
            case UISwipeGestureRecognizerDirectionDown://下
            {
                CGFloat lastY = y+(K_ITEMHEIGHT +padd);
                if (_colum>0) {
                    //滑人物
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        self.player.frame = CGRectMake(x, lastY,size.width,size.height);
                        
                    } completion:^(BOOL finished) {
                        //增加坐标
                        --_colum;
                    }];
                    
                }else{
                    if (self.scrollView.contentOffset.y < _scrollViewSize.height * 4 + (K_ITEMHEIGHT +padd)) {
                        //滑地图
                        [UIView animateWithDuration:0.2 animations:^{
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y+(K_ITEMHEIGHT +padd)) animated:NO];
                            self.player.frame = CGRectMake(x, lastY, size.width, size.height);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }
            }
                break;
            case UISwipeGestureRecognizerDirectionRight://右
            {
                CGFloat lastX = x+(K_ITEMWIDTH +padd);
                if (_row<1) {
                    //滑人物
                    [UIView animateWithDuration:0.2 animations:^{
                        self.player.frame = CGRectMake(lastX, y, size.width, size.height);
                    } completion:^(BOOL finished) {
                        ++_row;
                        
                    }];
                }else{
                    //滑地图
                    if (self.scrollView.contentOffset.x < self.scrollViewSize.width *3 +(K_ITEMWIDTH +padd)) {
                        [UIView animateWithDuration:0.2 animations:^{
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+(K_ITEMWIDTH +padd), self.scrollView.contentOffset.y) animated:NO];
                            self.player.frame = CGRectMake(lastX, y, size.width, size.height);
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }
            }
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark------定时器刷新 UI 界面
-(void)updateMoveViewFrame{
    for (UIImageView *view in self.moveArray) {
        //重新绘制动画过程中的 frame
        view.frame = view.layer.presentationLayer.frame;
        [view setNeedsDisplay];
    }
    //判断有没有捡到碎片
    if (fabs(self.player.layer.presentationLayer.frame.origin.x+16-(self.targetView.centerX + self.playerMoveScopeView.x)) <16 &&
        fabs(self.player.layer.presentationLayer.frame.origin.y+16-(self.targetView.centerY + self.playerMoveScopeView.y)) <16  && fabs([_date timeIntervalSinceNow])>0.25) {
        _date = [NSDate date];
        //检测到捡到了碎片以后的处理，首先暂停所有动画
        [self pauseLayer];
        //弹框；
        ++_index;
        
        if (_index == 6 || _index == 12 || _index == 18) {
            NSLog(@"第几关开始了 %ld",_index / 6 + 1);
            //如果是第六长卷轴，那么进入下一关
            self.type = K_OtherType;
            
            ++_customPassValue;
            
        }else{
            
            self.type = K_JuanZhouType;
        }
        
        [[YYTAlertView showFetchAlertViewWithType:self.type andType:0 andBlcok:^(NSUInteger checkPoint){
            if (_index == 6) {
                //进入下一关
                NSLog(@"第二关的相关设置");
                
                //第二关的相关设置
                [self theSecondCustomSet];
                
//                [NSThread sleepForTimeInterval:5];
                
            }else if(_index ==  12) {
            //继续随机卷轴
                NSLog(@"第三关的相关设置");
                [self theThreeCustomSet];
                
            }else if (_index == 18){
                NSLog(@"恭喜你闯关成功了");
            }
            if (_index %2 == 0) {
                _targetView.center = [self.cursesBottomBooks[arc4random()%3] CGPointValue];
            }else{
                _targetView.center = [self.cursesTopBooks[arc4random()%3] CGPointValue];
            }
            [self sureButtonClick];
        } aandAdd:[[UIApplication sharedApplication] keyWindow] and:NO] show];
    }
    
    //判断有没有碰上移动障碍物
    for (UIImageView *view in self.moveArray) {
        //绘制完了判断有没有相撞
        if (fabs(self.player.layer.presentationLayer.frame.origin.x+16-view.centerX) <16 &&
            fabs(self.player.layer.presentationLayer.frame.origin.y+16-view.centerY) <16) {
            if (fabs([_date timeIntervalSinceNow])>0.5) {
                //如果距离上次撞击大于1秒
                _date = [NSDate date];
                
                //血条的处理
                _count = _count - 28;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"K_LLIFEVALUE" object:nil userInfo:@{@"key":[NSNumber numberWithUnsignedInteger:_count]}];
                
                [self pauseLayer];
                viewType type = K_tagViewFourType;
                [[YYTAlertView showFetchAlertViewWithType:K_ZhangAiWUType andType:type andBlcok:^(NSUInteger checkPoint){

                    [self sureButtonClick];
                    
                } aandAdd:[[UIApplication sharedApplication] keyWindow] and:NO] show];
                
                break;
            }
        }
    }
    
}

/**
 第二关的相关设置
 */
-(void)theSecondCustomSet{
    for (int i = 0; i< [self.moveArray count]; i++) {
                UserStorePointModel *model = [self.points objectAtIndex:i];
                model.row = i%10 *2+1;
                model.colum =2 * i/10;
                UIImageView *imageView = [self.moveArray objectAtIndex:i];
                imageView.frame = CGRectMake(i%10*(K_ITEMWIDTH+padd)*2-15+K_ITEMWIDTH+padd, i/10*(K_ITEMHEIGHT+padd) *2-15, padd, padd);
    }
    NSLog(@"布局完成");
//    [NSThread sleepForTimeInterval:3];
    
    
}
-(void)theThreeCustomSet{
    
    for (int i = 0; i< [self.moveArray count]; i++) {
        UserStorePointModel *model = [self.points objectAtIndex:i];
        model.row = i%10 * 2 +1;
        model.colum = i/10;
        UIImageView *imageView = [self.moveArray objectAtIndex:i];
        imageView.frame = CGRectMake(i%10*(K_ITEMWIDTH+padd)*2-15+K_ITEMWIDTH+padd, i/10*(K_ITEMHEIGHT+padd)-15, padd, padd);
    }
    NSLog(@"布局完成");
//    [NSThread sleepForTimeInterval:3];
}
-(void)sureButtonClick{
    
    [self resumeLayer];
    _date = [NSDate date];
}


#pragma mark------CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    @synchronized (self) {
        NSUInteger count = [[anim valueForKey:@"animationIndex"] integerValue];
        UIImageView *imageView = [self.moveArray objectAtIndex:count];
        UserStorePointModel *model = [self.points objectAtIndex:count];
        imageView.frame = CGRectMake(model.row*(K_ITEMWIDTH+padd)-15, model.colum*(K_ITEMHEIGHT+padd)-15, padd, padd);
        self.completion(count);
    }
}

#pragma mark------UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return [self.view viewWithTag:45];
}
//碰撞了的时候处理血条问题
//-(void)impact{
//    // 系统progress
//    [progressV1 setProgress:(arc4random() % 322)/322.0 animated:YES];
//    // 未封装 progressview
//    int maxValue = 280;
//    // 变量
//    CGFloat tempValue = (arc4random() % maxValue) *10.0f;
//
//    CGFloat progressWidth = tempValue/10.f;
//
//    double durationValue = (tempValue/2.0) / (maxValue * 10.0f) + .5 ;
//
//    [UIView animateWithDuration:durationValue animations:^{
//
//        progressV.width = progressWidth;
//    }];
//    // YSProgressView
//    _value.progressValue = progressWidth;
//}
//
-(UIView *)playerMoveScopeView{
    if (!_playerMoveScopeView) {
        UIView *view = [self.view viewWithTag:45];
        _playerMoveScopeView = [[UIView alloc]initWithFrame:CGRectInset(view.frame, K_UISCREEN_WIDTH-15, (K_UISCREEN_HEIGHT-K_stateBarHeight-15))];
        _playerMoveScopeView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_playerMoveScopeView.bounds];
        imageView.image = [UIImage imageNamed:@"bg"];
        [_playerMoveScopeView addSubview:imageView];
        
        //创建大地图背景
        for (int i = 0; i<20; i++) {
            for (int j = 0; j<12; j++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(padd+(padd+K_ITEMWIDTH)*j, padd+(padd +K_ITEMHEIGHT)*i, K_ITEMWIDTH, K_ITEMHEIGHT)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.image = [UIImage imageNamed:@"borderline"];
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 65.6)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentCenter;
                NSInteger index = arc4random()%27;
                label.text = [self.titles objectAtIndex:index];
                label.numberOfLines = 2;
                label.font = [UIFont systemFontOfSize:50 weight:15];
                label.font  =[UIFont fontWithName:@"FZXiaoZhuanTi-S13T" size:23];
                label.shadowColor = [UIColor whiteColor];
                label.shadowOffset = CGSizeMake(1, 1);
                [imageView addSubview:label];
                [_playerMoveScopeView addSubview:imageView];
                
            }
        }
        
    }
    return _playerMoveScopeView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-----动画的暂停与继续
//暂停添加到这个视图上的动画效果
- (void)pauseLayer{
    //也暂停定时器
    _linkDisplay.paused = YES;
    //暂停动画
    for (UIImageView *view in self.moveArray) {
        CFTimeInterval pausedTime = [view.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        view.layer.speed = 0.0;
        view.layer.timeOffset = pausedTime;
    }
}
//继续layer上面的动画
- (void)resumeLayer{
    //打开定时器
    _linkDisplay.paused = NO;
    
    for (UIImageView *imageView in self.moveArray) {
        CFTimeInterval pausedTime = [imageView.layer timeOffset];
        imageView.layer.speed = 1;
        imageView.layer.timeOffset = 0.0;
        imageView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        imageView.layer.beginTime = timeSincePause;
    }
}

-(BOOL)fetchLocationBaseBackground:(CGRect)currentFrame andDirection:(int)value{
    
    CGRect currentRect = CGRectMake(currentFrame.origin.x,currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height);
    return (currentRect.origin.y <= 0                         && value == 0) ||
    (currentRect.origin.y >= _contentSize.height       && value == 1) ||
    (currentRect.origin.x <= 0                         && value == 2) ||
    (currentRect.origin.x >= _contentSize.width        && value == 3)?
    NO:YES;
    
}
//处理在指定方向上移动一个单位
-(void)fetchAllStateMoveViewToChangeValue:(CABasicAnimation *)animation and:(NSInteger)value andView:(UIImageView *)imageView andModel:(UserStorePointModel *)model{
    
    switch (value) {
        case 0:
        {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(imageView.centerX, imageView.centerY-95)];
            model.colum = model.colum - 1;
        }
            break;
        case 1:
        {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(imageView.centerX, imageView.centerY+K_ITEMHEIGHT+padd)];
            model.colum = model.colum + 1;
        }
            break;
            
        case 2:
        {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(imageView.centerX-K_ITEMWIDTH-padd, imageView.centerY)];
            model.row = model.row - 1;
        }
            break;
            
        case 3:
        {
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(imageView.centerX+K_ITEMWIDTH+padd, imageView.centerY)];
            model.row = model.row + 1;
        }
            break;
        default:
            break;
    }
    [imageView.layer addAnimation:animation forKey:@"animation"];
    
}


@end
