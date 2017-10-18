//
//  SWAudioPlayer.h
//  Swallow
//
//  Created by lawn.cao on 2017/10/18.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 播放模式

 - SWAudioPlayerMode_Repeat: 单曲循环
 - SWAudioPlayerMode_Order: 顺序播放
 - SWAudioPlayerMode_Random: 随机播放
 */
typedef NS_ENUM(NSUInteger, SWAudioPlayerMode) {
    SWAudioPlayerMode_Repeat = 0,
    SWAudioPlayerMode_Order = 1,
    SWAudioPlayerMode_Random = 2
};

@interface SWAudioPlayer : NSObject

/// 播放模式
@property (nonatomic, assign) SWAudioPlayerMode playModel;
/// 播放本地文件路径
@property (nonatomic, copy  ) NSString *resourcePath;
/// 批量播放文件
@property (nonatomic, strong) NSArray *resourcePaths;
/// 播放在线文件路径(暂不支持)
@property (nonatomic, copy  ) NSString *resourceURL;
/// 是否正在播放
@property (nonatomic, readonly, assign) BOOL isPlaying;


/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

@end
