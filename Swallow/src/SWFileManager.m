//
//  SWFileManager.m
//  Swallow
//
//  Created by lawn.cao on 2017/10/19.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import "SWFileManager.h"

#define kSWFile_Document ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

@interface SWFileManager()

@property (nonatomic, strong) NSArray *filePathList;

@end

#pragma mark - SWFileManager

@implementation SWFileManager

+ (instancetype)manager
{
    static SWFileManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self updateFilePathList];
    }
    return self;
}

- (void)moveFileToDocumentWithURL:(NSURL *)url
{
    if (!url) {
        return;
    }
    
    // 文件路径
    if (url.isFileURL) {
        
        NSString *fileName = [url.pathComponents lastObject];
        NSString *date = [self dateString];
        
        NSRange range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            date = [NSString stringWithFormat:@"_%@.", date];
            fileName = [fileName stringByReplacingCharactersInRange:range withString:date];
        }else{
            fileName = [NSString stringWithFormat:@"%@_%@", fileName, date];
        }
        
        NSString *fromPath = url.relativePath;
        NSString *toPath = [kSWFile_Document stringByAppendingPathComponent:fileName];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:fromPath]) {
            if ([manager copyItemAtPath:fromPath toPath:toPath error:nil]) {
                [manager removeItemAtPath:fromPath error:nil];
                [self updateFilePathList];
            }
        }
    }
}

- (NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[NSDate date]];
}


- (void)updateFilePathList
{
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    NSString *documentPath = kSWFile_Document;
    NSArray *names = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    for (NSString *name in names) {
        NSString *path = [documentPath stringByAppendingPathComponent:name];
        [paths addObject:path];
    }
    self.filePathList = paths;
}


@end
