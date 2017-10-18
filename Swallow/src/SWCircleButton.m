//
//  SWCircleButton.m
//  Swallow
//
//  Created by lawn.cao on 2017/10/18.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import "SWCircleButton.h"

@implementation SWCircleButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width/2.0f;
    self.clipsToBounds = YES;
}

@end
