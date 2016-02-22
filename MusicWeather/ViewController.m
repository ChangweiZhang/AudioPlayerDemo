//
//  ViewController.m
//  MusicWeather
//
//  Created by 张昌伟 on 16/2/22.
//  Copyright © 2016年 Changwei Zhang. All rights reserved.
//

#import "ViewController.h"
#import "LrcParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *lrcTable;

@property (strong,nonatomic) LrcParser* lrcContent;

@property (nonatomic,strong) NSTimer *timer;

@property (assign) NSInteger currentRow;

@property (nonatomic,copy) NSArray *songs;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.lrcTable.delegate=self;
    self.lrcTable.dataSource=self;
    self.lrcContent=[[LrcParser alloc] init];
    [self.lrcContent parseLrc];
    [self.lrcTable reloadData];
    [self initPlayer];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    UIImage *img=[UIImage imageNamed:@"wall1.jpg"];
    
    UIImageView *bgView=[[UIImageView alloc] initWithImage:img];
    //bgView.alpha=0.8;
    self.lrcTable.backgroundView=bgView;
    [bgView setImage:[self getBlurredImage:img]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcContent.wordArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self.lrcTable dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=self.lrcContent.wordArray[indexPath.row];
    if(indexPath.row==_currentRow)
        cell.textLabel.textColor = [UIColor redColor];
    else
        cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.backgroundColor=[UIColor clearColor];
   
    return cell;
}

-(void) setPlayerUrl:(NSURL *)url{
    //[self.player ini
    
}

-(void) initPlayer{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle]  URLForResource:@"冰雨" withExtension:@"mp3"] error:nil];
    self.player.numberOfLoops=10;
    [self.player prepareToPlay];
    [self.player play];
    
}

-(void) updateTime{
    CGFloat currentTime=self.player.currentTime;
    NSLog(@"%d:%d",(int)currentTime / 60, (int)currentTime % 60);
    for (int i=0; i<self.lrcContent.timerArray.count; i++) {
        NSArray *timeArray=[self.lrcContent.timerArray[i] componentsSeparatedByString:@":"];
        float lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue];
        if(currentTime>lrcTime){
            _currentRow=i;
        }else
            break;
    }
    
    [self.lrcTable reloadData];
    [self.lrcTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

//实现高斯模糊
-(UIImage *)getBlurredImage:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage=[CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter=[CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@5.0f forKey:@"inputRadius"];
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef ref=[context createCGImage:result fromRect:[result extent]];
    return [UIImage imageWithCGImage:ref];
}
@end
