//
//  SWFileManager.h
//  Swallow
//
//  Created by lawn.cao on 2017/10/19.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWFileManager : NSObject

@property (nonatomic, readonly, strong) NSArray *filePathList;

+ (instancetype)manager;

- (void)moveFileToDocumentWithURL:(NSURL *)url;

@end

