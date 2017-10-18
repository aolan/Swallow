//
//  ViewController.m
//  Swallow
//
//  Created by lawn.cao on 2017/10/18.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import "SWHomeViewController.h"
#import "SWCircleButton.h"

@interface SWHomeViewController ()

@property (nonatomic, strong) SWCircleButton *playButton;
@property (nonatomic, strong) SWCircleButton *syncButton;
@property (nonatomic, strong) SWCircleButton *manageButton;

@end


@implementation SWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.syncButton];
    [self.view addSubview:self.manageButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
}


#pragma mark - Getter Methods

- (SWCircleButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [SWCircleButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitle:@"播放" forState: UIControlStateNormal];
    }
    return _playButton;
}

@end
