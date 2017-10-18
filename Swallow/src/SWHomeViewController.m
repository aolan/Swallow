//
//  ViewController.m
//  Swallow
//
//  Created by lawn.cao on 2017/10/18.
//  Copyright © 2017年 lawn. All rights reserved.
//

#import "SWHomeViewController.h"
#import "SWCircleButton.h"
#import "SWAudioPlayer.h"
#import "SWFileManager.h"

static CGFloat const kSWHomeViewController_CircleButton_Bottom = 20.0f;
static CGFloat const kSWHomeViewController_CircleButton_Leading = 20.0f;
static CGFloat const kSWHomeViewController_CircleButton_WH = 60.0f;
static CGFloat const kSWHomeViewController_CircleButton_Padding = 20.0f;

#define kSWHomeViewController_CircleButton_Font ([UIFont systemFontOfSize:10])


@interface SWHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SWCircleButton *playButton;
@property (nonatomic, strong) SWCircleButton *pauseButton;
@property (nonatomic, strong) SWAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSArray *paths;

@end


@implementation SWHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.pauseButton];
    
    [self.view setNeedsUpdateConstraints];
    
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:[SWFileManager manager]
                        keyPath:@"filePathList"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                              __strong typeof(weakSelf) strongSelf = weakSelf;
                              strongSelf.paths = change[NSKeyValueChangeNewKey];
                              [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Action Methods

- (void)playAction
{
    NSString *originResourcePath = self.audioPlayer.resourcePath;
    self.audioPlayer.resourcePaths = self.paths;
    if (originResourcePath) {
        self.audioPlayer.resourcePath = originResourcePath;
    }
    [self.audioPlayer play];
}

- (void)pauseAction
{
    [self.audioPlayer pause];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSString *path = [self.paths objectAtIndex:indexPath.row];
    NSArray *pathComponents = [path componentsSeparatedByString:@"/"];
    cell.textLabel.text = pathComponents.lastObject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.audioPlayer.resourcePaths = self.paths;
    NSString *path = [self.paths objectAtIndex:indexPath.row];
    self.audioPlayer.resourcePath = path;
    [self.audioPlayer play];
}

#pragma mark - Layout Methods

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    [self.playButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(kSWHomeViewController_CircleButton_Leading);
        make.width.mas_equalTo(kSWHomeViewController_CircleButton_WH);
        make.height.mas_equalTo(kSWHomeViewController_CircleButton_WH);
        make.bottom.mas_equalTo(self.pauseButton.mas_top).offset(-kSWHomeViewController_CircleButton_Padding);
    }];
    
    [self.pauseButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).offset(kSWHomeViewController_CircleButton_Leading);
        make.width.mas_equalTo(kSWHomeViewController_CircleButton_WH);
        make.height.mas_equalTo(kSWHomeViewController_CircleButton_WH);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kSWHomeViewController_CircleButton_Bottom);
    }];
}

#pragma mark - Getter Methods

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (SWCircleButton *)playButton
{
    if (_playButton == nil) {
        _playButton = [SWCircleButton buttonWithType:UIButtonTypeCustom];
        _playButton.titleLabel.font = kSWHomeViewController_CircleButton_Font;
        _playButton.backgroundColor = [UIColor blueColor];
        [_playButton setTitle:@"播放" forState: UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (SWCircleButton *)pauseButton
{
    if (_pauseButton == nil) {
        _pauseButton = [SWCircleButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.titleLabel.font = kSWHomeViewController_CircleButton_Font;
        _pauseButton.backgroundColor = [UIColor blueColor];
        [_pauseButton setTitle:@"暂停" forState: UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (SWAudioPlayer *)audioPlayer
{
    if (_audioPlayer == nil) {
        _audioPlayer = [[SWAudioPlayer alloc] init];
        _audioPlayer.playModel = SWAudioPlayerMode_Order;
    }
    return _audioPlayer;
}

@end
