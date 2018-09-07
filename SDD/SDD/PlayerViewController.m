//
//  PlayerViewController.m
//  SDD
//
//  Created by mac on 15/12/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayerViewController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //播放
    [self.moviePlayer play];
    
    //添加通知
    [self addNotification];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
}


-(NSURL *)getNetworkUrl:(NSString *)urlStr{
    //    "http://183.60.177.195:8888/uploadFile/userMobile/videos/20150814/Chengzhihuidian.mp4",
    //    "http://183.60.177.195:8888/uploadFile/userMobile/videos/20151112/chengzhihuidian.mp4"
    //    "http://183.60.177.195:8888/uploadFile/userMobile/videos/20150826/zhongliang480p.mp4"
    
    //    NSString *urlStr=@"http://183.60.177.195:8888/uploadFile/userMobile/videos/20151112/chengzhihuidian.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSURL *url=[self getNetworkUrl:@"http://183.60.177.195:8888/uploadFile/userMobile/videos/20151112/chengzhihuidian.mp4"];//@"http://183.60.177.195:8888/uploadFile/userMobile/videos/20151112/chengzhihuidian.mp4"
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame=self.view.bounds;
        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
       _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        //        [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
        [self.view addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
