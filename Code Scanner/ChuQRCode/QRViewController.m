//
//  QRViewController.m
//  ChuQRCode
//
//  Created by Xes.Sky.Macbook on 2016/11/4.
//  Copyright © 2016年 Xes.Sky.Macbook. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface QRViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureDevice * device;         //provides realtime input media data
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output; //can be used to process metadata objects from an attached connection.
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * QRPreview;
@property (nonatomic, copy) resultCallBack callback;            // callback function

@end

@implementation QRViewController

- (instancetype)initWithCallback:(resultCallBack)callback
{
    self = [super init];
    if (self) {
        self.callback = callback;
    }
    return self;
}

- (BOOL)checkCameraAuthorization {
    //Returns a constant indicating whether the app has permission for recording a specified media type
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"can't access camara" message:nil
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"confirm"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)setupCamera {
    
    //Initialize Objects
    //Set the MediaType
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //The device from which to capture input.
    self.input  = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    if (self.output) {
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // An array of strings identifying the types of metadata objects to process.
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code,
                                            AVMetadataObjectTypeUPCECode,
                                            AVMetadataObjectTypeCode39Code,
                                            AVMetadataObjectTypeCode39Mod43Code,
                                            AVMetadataObjectTypeCode93Code,
                                            AVMetadataObjectTypePDF417Code,
                                            AVMetadataObjectTypeAztecCode,
                                            AVMetadataObjectTypeInterleaved2of5Code,
                                            AVMetadataObjectTypeITF14Code,
                                            AVMetadataObjectTypeDataMatrixCode];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    if ([self checkCameraAuthorization]) {
        [self setupCamera];
        
        self.QRPreview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.QRPreview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.QRPreview.frame = self.view.layer.bounds;
        [self.view.layer addSublayer:self.QRPreview];
        //启动session 开始扫描
        [self.session  startRunning];
    }
    
}



#pragma mark -------------------- AVCaptureMetadataOutputObjectsDelegate  --------------------
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        if (self.callback) {
            self.callback(metadataObject.stringValue);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
