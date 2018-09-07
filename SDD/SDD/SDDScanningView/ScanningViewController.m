//
//  ScanningViewController.m
//  SDD
//
//  Created by mac on 15/5/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDDWebViewController.h"

@interface ScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
 
    [self setupNav];
    
    [self readQRCode];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.session stopRunning];
    
    [self.previewLayer removeFromSuperlayer];
    
    [super viewDidDisappear:animated];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readQRCode
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        NSLog(@"------%@",error.localizedDescription);
        
        return;
    }
    
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    
    [session addInput:input];
    [session addOutput:output];
    
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CGFloat previewWH = 260;
    
    [preview setFrame:CGRectMake(viewWidth /2 - previewWH /2, viewHeight /2 - previewWH /2 - 64, previewWH, previewWH)];
    
    [self.view.layer insertSublayer:preview atIndex:0];
    
    self.previewLayer = preview;
    self.session = session;
    
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];
    
    [self.previewLayer removeFromSuperlayer];
    
    NSLog(@"=====%@", metadataObjects);
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        
     
        SDDWebViewController *webView = [[SDDWebViewController alloc]init];
        [webView loadWithURLString:[NSString stringWithFormat:@"%@",obj.stringValue]];
        NSLog(@"%@", obj);
        
        [self.navigationController pushViewController:webView animated:YES];
    }
    
}




@end
