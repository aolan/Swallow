//
//  SWAudioPlayer.m
//  Swallow
//
//  Created by lawn.cao on 2017/10/18.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import "SWAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SWAudioPlayer()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL isPlaying;

@end



@implementation SWAudioPlayer


#pragma mark - Command Methods

- (void)play
{
    if (!self.player.currentItem) {
        NSLog(@"还没有选择播放资源");
        return;
    }
    
    self.isPlaying = YES;
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.KVOController unobserve:self.player.currentItem];
        [self.player play];
    }
}

- (void)pause
{
    self.isPlaying = NO;
    [self.player pause];
}



#pragma mark - Set Resouce

- (void)setResourcePath:(NSString *)resourcePath
{
    _resourcePath = resourcePath;
    
    NSURL *url = [NSURL fileURLWithPath:resourcePath];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [self replacePlayerItem:item];
}

- (void)setResourceURL:(NSString *)resourceURL
{
    _resourceURL = resourceURL;

    NSURL *url = [NSURL URLWithString:resourceURL];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    [self replacePlayerItem:item];
}

- (void)setResourcePaths:(NSArray *)resourcePaths
{
    _resourcePaths = resourcePaths;
    
    if (resourcePaths.count > 0) {
        self.resourcePath = resourcePaths.firstObject;
    }
}

- (void)replacePlayerItem:(AVPlayerItem *)item
{
    if (self.player.currentItem) {
        [self.KVOController unobserve:self.player.currentItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.player.currentItem];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:item
                        keyPath:@"status"
                        options:NSKeyValueObservingOptionNew
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change){
                              AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
                              __strong typeof(weakSelf) strongSelf = weakSelf;
                              if (status == AVPlayerItemStatusReadyToPlay) {
                                  if (strongSelf.isPlaying) {
                                      [strongSelf.player play];
                                  }
                              }
                          }];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinished)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:item];
}

#pragma mark - Private Methods

- (void)playFinished
{
    self.isPlaying = NO;

    if (self.player.currentItem) {
        
        switch (self.playModel) {
            // 单曲循环
            case SWAudioPlayerMode_Repeat:{
                [self.player.currentItem seekToTime:kCMTimeZero completionHandler:NULL];
                [self play];
                break;
            }
            // 顺序播放
            case SWAudioPlayerMode_Order:{
                NSUInteger playingIndex =  [self.resourcePaths indexOfObject:self.resourcePath];
                NSLog(@"====%lu, %lu", (unsigned long)playingIndex, (unsigned long)self.resourcePaths.count);
                self.resourcePath = [self.resourcePaths objectAtIndex:(++playingIndex % self.resourcePaths.count)];
                [self play];
                break;
            }
            // 随机播放
            case SWAudioPlayerMode_Random:{
                NSUInteger playedIndex =  [self.resourcePaths indexOfObject:self.resourcePath];
                NSUInteger playingIndex = arc4random() % self.resourcePaths.count;
                if (playingIndex == playedIndex) {
                    playingIndex++;
                }
                self.resourcePath = [self.resourcePaths objectAtIndex:(playingIndex % self.resourcePaths.count)];
                [self play];
                break;
            }
            default:{
                break;
            }
        }
    }
}


#pragma mark - Getter Methods

- (AVPlayer *)player
{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                              queue:dispatch_get_main_queue()
                                         usingBlock:^(CMTime time) {
            
                                             float current = CMTimeGetSeconds(time);
                                             NSLog(@"%f", current);
                                             
        }];
    }
    return _player;
}

@end
