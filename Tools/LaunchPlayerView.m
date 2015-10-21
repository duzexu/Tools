//
//  LaunchPlayerView.m
//  VideoWelcome
//
//  Created by yemalive on 15/7/16.
//  Copyright (c) 2015年 Chinsyo. All rights reserved.
//

const float PLAYER_VOLUME = 0.0;

#import "LaunchPlayerView.h"

@interface LaunchPlayerView () {
    CMTime time;
}

@property (nonatomic , strong) AVPlayer *player;

@end

@implementation LaunchPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (instancetype)initWithVideoName:(NSString *)video {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self createPlayerWithVideoName:video];
    }
    return self;
}

- (void)createPlayerWithVideoName:(NSString *)video {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:video ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    self.player = [AVPlayer playerWithURL:url];
    self.player.volume = PLAYER_VOLUME;
    
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer setPlayer:_player];
    [_player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidPause:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidStart:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [_player play];
}

- (void)moviePlayDidPause:(NSNotification *)notification {
    [_player pause];
}

- (void)moviePlayDidStart:(NSNotification *)notification {
    [_player play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
