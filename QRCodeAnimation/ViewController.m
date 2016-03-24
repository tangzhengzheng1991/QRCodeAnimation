//
//  ViewController.m
//  QRCodeAnimation
//
//  Created by tangzhengzheng on 16/3/23.
//  Copyright © 2016年 tangzhengzheng. All rights reserved.
//
//屏幕的宽 iPhone iPad 通用
#define ScreenWidth (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
//屏幕的高 iPhone iPad 通用
#define ScreenHeight (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
#define SYSTEM_VERSION() [[UIDevice currentDevice].systemVersion floatValue]

#define USER_D [NSUserDefaults standardUserDefaults]


#import "ViewController.h"

//#import "zbar.h"

#import "QRCodeGenerator.h"

@interface ViewController ()
{
    int num;
    
    BOOL upOrdown;
    NSTimer * timer;
    
    UIButton *_BigImageView ;
    UIImageView * _line;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self headView];
}


//头部视图
-(void)headView{
    
    UIView *bacgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.3)];
    
    [self.view addSubview:bacgroundView];
    
    [bacgroundView setBackgroundColor:[UIColor blackColor]];
    
    
    
    CGFloat iconW = 25/375.0*ScreenWidth;
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(23, 30, iconW, iconW)];
    icon.image=[UIImage imageNamed:@"icon"];
    [bacgroundView addSubview:icon];
    
    
    
    
    CGFloat buttonW=60/375.0*ScreenWidth;
    CGFloat buttonX = 65/375.0*ScreenWidth;
    CGFloat buttonY = 95/212.0*ScreenHeight*0.3;
    
    
    //扫描二维码按钮
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame=CGRectMake(buttonX, buttonY, buttonW, 100);
    [scanButton addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.tag=0;
    [bacgroundView addSubview:scanButton];
    
    //扫描二维码图片
    CGFloat scanImageviewW=50/60.0*buttonW;
    CGFloat scanImageviewX= (buttonW-scanImageviewW)/2.0;
    UIImageView *scanImageview = [[UIImageView alloc] initWithFrame:CGRectMake(scanImageviewX, 0, scanImageviewW, scanImageviewW)];
    scanImageview.image = [UIImage imageNamed:@"icon01"];
    [scanButton addSubview:scanImageview];
    
    
    
    //扫描二维码标签
    UILabel *scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, scanImageviewW+10, buttonW, 20)];
    scanLabel.font= [UIFont systemFontOfSize:14];
    scanLabel.textAlignment = NSTextAlignmentCenter;
    scanLabel.textColor=[UIColor whiteColor];
    scanLabel.text=@"扫一扫";
    [scanButton addSubview:scanLabel];
    
    
    
    //生成二维码
    
    CGFloat QRButtonX = ScreenWidth-buttonX-buttonW;
    
    UIButton *QRButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QRButton.frame = CGRectMake(QRButtonX, buttonY, buttonW, 100);
    [QRButton addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
    QRButton.tag=1;
    [bacgroundView addSubview:QRButton];
    
    
    
    //生成二维码图片
    CGFloat QRImageviewW=50/60.0*buttonW;
    CGFloat QRImageviewX= (buttonW-scanImageviewW)/2.0;
    
    UIImageView *QRImageview = [[UIImageView alloc] initWithFrame:CGRectMake(QRImageviewX, 0, QRImageviewW, QRImageviewW)];
    QRImageview.image=[UIImage imageNamed:@"icon02"];
    [QRButton addSubview:QRImageview];
    
    //生成二维码标签
    UILabel *QRLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, QRImageviewW+10, buttonW, 20)];
    QRLabel.font= [UIFont systemFontOfSize:14];
    QRLabel.textAlignment = NSTextAlignmentCenter;
    QRLabel.textColor=[UIColor whiteColor];
    QRLabel.text=@"二维码";
    [QRButton addSubview:QRLabel];
    
    
}


#pragma mark -点击方法
-(void)pushButton:(UIButton *)button{
    if (button.tag==0) {
        NSLog(@"扫描二维码");
        if (SYSTEM_VERSION()>=7.0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]; // 获取对摄像头的访问权限。
            if (authStatus==AVAuthorizationStatusDenied ||authStatus == AVAuthorizationStatusRestricted ) {
                [[[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请去“设置<隐私<相机”，为应用打开相机功能，再重新进入本页面！" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
                return;
            }
            [self scanBtnAction];
        }
        
    }else if(button.tag==1){
        NSLog(@"生成二维码");
        
        [self erweimaview];
        
        
        
        
        
        
    }
    
    
}

//生成二维码

-(void)erweimaview
{
    //    UIButton *erWeiMaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    erWeiMaButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    _BigImageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _BigImageView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.56];
    [_BigImageView addTarget:self action:@selector(bigimageViewClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *erWeiMaImageView2 = [[UIImageView  alloc]init];
    erWeiMaImageView2.center = _BigImageView.center;
    erWeiMaImageView2.bounds = CGRectMake(0, 0, 250, 250);
    erWeiMaImageView2.backgroundColor = [UIColor whiteColor];
    [_BigImageView addSubview:erWeiMaImageView2];
    
    UIImageView *erWeiMaImageView = [[UIImageView  alloc]init];
    //    erWeiMaImageView.center = BigImageView.center;
    erWeiMaImageView.frame = CGRectMake(0, 0, 250, 250);
    erWeiMaImageView.backgroundColor = [UIColor whiteColor];
    [erWeiMaImageView2 addSubview:erWeiMaImageView];
    
    erWeiMaImageView.image = [QRCodeGenerator qrImageForString:@"http://blog.csdn.net/u013061302" imageSize:erWeiMaImageView.bounds.size.width];
    NSArray * arr = [[UIApplication sharedApplication] windows];
    UIWindow * window = arr[0];
    
    [window addSubview:_BigImageView];
}
-(void)bigimageViewClick
{
    [_BigImageView removeFromSuperview];
    
}




-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    
    int i = 0;
    for (UIView *temp in [reader.view subviews]) {
        for (UIView *v in [temp subviews]) {
            if ([v isKindOfClass:[UIToolbar class]]) {
                for (UIView *ev in [v subviews]) {
                    
                    if (i== 3) {
                        [ev removeFromSuperview];
                    }
                    i++;
                }
            }
        }
        
        
    }
    ZBarReaderView *readerView;
    readerView.torchMode = 1;
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    reader.showsZBarControls = YES;
    reader.tracksSymbols = YES;
    
    UIView * OverlayView = [[UIView alloc] init];
    OverlayView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    OverlayView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    OverlayView.backgroundColor = [UIColor clearColor];
    
    if (SYSTEM_VERSION() < 8.0){
        
        //  self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.barTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.navigationController.navigationBar.translucent = NO;
        OverlayView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
        //self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    reader.cameraOverlayView = OverlayView;
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    //    image.backgroundColor=[UIColor redColor];
    image.frame = CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 250) / 2, 250, 250);
    [OverlayView addSubview:image];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(image.frame.origin.x, 0, self.view.frame.size.width - image.frame.origin.x * 2, image.frame.origin.y)];
    view1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [OverlayView addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.frame.origin.x, self.view.frame.size.height)];
    view2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [OverlayView addSubview:view2];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250) / 2 + image.frame.size.width, 0, (self.view.frame.size.width - 250) / 2, self.view.frame.size.height)];
    view3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [OverlayView addSubview:view3];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(image.frame.origin.x,image.frame.origin.y + image.frame.size.height, self.view.frame.size.width - image.frame.origin.x * 2, self.view.frame.size.height - image.frame.origin.y - image.frame.size.height)];
    view4.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [OverlayView addSubview:view4];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(-10, 20, 280, 40)];
    label.text = @"请将扫描的二维码放入框内\n即可自动扫描";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view4 addSubview:label];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间
    timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    // [self presentModalViewController:reader animated:YES];
    [self presentViewController:reader animated:YES completion:nil];
}

- (void)animation1
{
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    //    image.backgroundColor=[UIColor redColor];
    image.frame = CGRectMake((self.view.frame.size.width - 250) / 2, (self.view.frame.size.height - 250) / 2, 250, 250);
    
    
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(15, 0+num, 220, 2);
        if (num == 250) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(15, 0+num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(0, 0, 250, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result = symbol.data;
        NSLog(@"result  ==%@",result);
        
        [self QRCodeShow:result];
        
        
        
        
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (SYSTEM_VERSION() < 8.0){
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:169.0/255.0 green:184.0/255.0 blue:60.0/255.0 alpha:1];
    }
    [timer invalidate];
    _line.frame = CGRectMake(0, 0, 250, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

-(void)QRCodeShow:(NSString *)QRString{
    
    
    _BigImageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _BigImageView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.56];
    [_BigImageView addTarget:self action:@selector(bigimageViewClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *QRStringView = [[UIImageView  alloc]init];
    QRStringView.center = _BigImageView.center;
    QRStringView.bounds = CGRectMake(20, 0, ScreenHeight-40, 80);
    QRStringView.layer.cornerRadius=5;
    QRStringView.layer.masksToBounds=YES;
    QRStringView.backgroundColor = [UIColor whiteColor];
    
    
    //扫描二维码标签
    UILabel *StringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    StringLabel.font= [UIFont systemFontOfSize:14];
    StringLabel.textAlignment = NSTextAlignmentCenter;
//    StringLabel.textColor=[UIColor whiteColor];
    StringLabel.text=QRString;
    [QRStringView addSubview:StringLabel];
    
    [_BigImageView addSubview:QRStringView];
    NSArray * arr = [[UIApplication sharedApplication] windows];
    UIWindow * window = arr[0];
    [window addSubview:_BigImageView];
    
    
    
    
    
}

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }
    
    @end
