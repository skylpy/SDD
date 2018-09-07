//
//  MPPlayerView.m
//  SDD
//
//  Created by mac on 15/5/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MPPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation MPPlayerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void) createMediaPlayerController:(NSString *)aFullString
{
    NSURL *urlString = [NSURL URLWithString:aFullString];
    
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:urlString];
    
    [self addSubview:moviePlayer.view];
    
    moviePlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, 240);
    
    [moviePlayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackState:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayer];

}

- (void)moviePlaybackState:(NSNotification *)noti
{
    MPMoviePlayerController *toMovie = [noti object];
    
    MPMoviePlaybackState playState = toMovie.playbackState;
    
    if (playState == MPMoviePlaybackStateStopped) {
        NSLog(@"停止");
    } else if (playState == MPMoviePlaybackStatePlaying) {
        NSLog(@"播放");
    } else if (playState == MPMoviePlaybackStatePaused) {
        NSLog(@"暂停");
    }

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:toMovie];
    
}



@end
