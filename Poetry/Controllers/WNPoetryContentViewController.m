//
//  WNPoetryContentViewController.m
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNPoetryContentViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
@interface WNPoetryContentViewController ()<AVSpeechSynthesizerDelegate>
@property(nonatomic,strong) WNPoetry *poetry;
@property(nonatomic,strong)  AVSpeechSynthesizer *readSynthesizer;
@property(nonatomic,assign) CGPoint pitchMultiplierPoint;
@property(nonatomic,strong) AVSpeechUtterance *readUtterance;
@property(nonatomic,assign) BOOL isPanGesAnimation;
@end

@implementation WNPoetryContentViewController

-(AVSpeechUtterance *)readUtterance{
    if (!_readUtterance) {
        _readUtterance = [[AVSpeechUtterance alloc]init];
        _readUtterance.pitchMultiplier = 1.0;
        
    }
    return _readUtterance;
}
-(AVSpeechSynthesizer *)readSynthesizer{
    if (_readSynthesizer==nil) {
        _readSynthesizer = [[AVSpeechSynthesizer alloc]init];
        _readSynthesizer.delegate = self;
    }
    return _readSynthesizer;
}
-(instancetype)initWithPoetry:(WNPoetry *)poetry{
    if (self = [super init]) {
        self.poetry = poetry;
    }
    return self;
}
- (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([obj class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [obj valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

-(void)pan:(UIPanGestureRecognizer*)sender{
    if (self.isPanGesAnimation) {
        return;
    }
    CGPoint point = [sender translationInView:self.view];
    CGPoint pointSelf = self.pitchMultiplierPoint;
    pointSelf.y -=point.y;
    if(pointSelf.y>200){
        pointSelf.y=200;
    }else if (pointSelf.y<0) {
        pointSelf.y=0;
    }
    self.pitchMultiplierPoint = pointSelf;
    [sender setTranslation:CGPointZero inView:self.view];
    UILabel *label;
    if ([self.view viewWithTag:10000]==nil) {
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/4)];
        [self.view addSubview:label];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 10000;
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        NSLog(@"%@",[self getAllPropertiesAndVaules:self.readUtterance]);
    }
    else{
        label = [self.view viewWithTag:10000];
    }
    label.text = [NSString stringWithFormat:@"语调：%.1lf",self.pitchMultiplierPoint.y/100];
    
    label.alpha = 0.8;
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //gai
        [self.readSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        self.readUtterance.pitchMultiplier = self.pitchMultiplierPoint.y/100.0;
        NSNumber *num = [NSNumber numberWithFloat:self.pitchMultiplierPoint.y/100.0];
        [self.readUtterance setValue:num forKey:@"pitchMultiplier"];
        [self.readSynthesizer continueSpeaking];
        self.isPanGesAnimation = YES;
        NSLog(@"%@",[self getAllPropertiesAndVaules:self.readUtterance]);
        [UIView animateWithDuration:1 animations:^{
            [self.view viewWithTag:10000].alpha = 0;
        } completion:^(BOOL finished) {
            self.isPanGesAnimation = NO;
        }];
    
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isLoading) {
        self.isLoading = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    self.view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:self.readSynthesizer.speaking?@"停止":@"朗读" style:UIBarButtonItemStylePlain target:self action:@selector(readPoetry)];
    
//    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.05, self.view.frame.size.width*0.9, self.view.frame.size.height*0.9)];
    UITextView *textView = [[UITextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = [NSString stringWithFormat:@"%@ -- %@\n\n%@\n\n%@\n",self.poetry.poetryTitle,self.poetry.poetryAuthor,self.poetry.poetryContent,self.poetry.poetryComment];
    textView.font = self.font;
    textView.editable = NO;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:textView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [self.view addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)readPoetry{
    
    if (self.readSynthesizer.speaking) {
        [self.readSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        return;
    }
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[self.poetry.poetryContent stringByAppendingString:self.poetry.poetryComment]];
    NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
//    utterance.rate = 0.5;
//    utterance.volume = 1;
    utterance.pitchMultiplier = self.readUtterance.pitchMultiplier;
    [self.readSynthesizer speakUtterance:utterance];
    self.readUtterance = utterance;
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.navigationItem.rightBarButtonItem.title = @"停止";
}
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    self.navigationItem.rightBarButtonItem.title = @"朗诗";
}
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    }

-(void)viewWillDisappear:(BOOL)animated{
    [self.readSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
}
-
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
