//
//  ViewController.m
//  AVFoundationDemo
//
//  Created by TangQiao on 12-10-16.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureDevice * videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput * videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput * frameOutput;
@property (nonatomic, strong) CIContext * context;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (CIContext *)context {
    if (_context == nil) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lib = [[ALAssetsLibrary alloc] init];
  
    debugMethod();

    // Session
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;

    // Input
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoDevice error:nil];

    // Output
    _frameOutput = [[AVCaptureVideoDataOutput alloc] init];
    _frameOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    [_frameOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

    [_session addInput:_videoInput];
    [_session addOutput:_frameOutput];
    
    toolbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar.png"]];
    toolbar.frame = CGRectMake(0,400,320,60);
    toolbar.contentMode = UIViewContentModeScaleToFill;
    toolbar.userInteractionEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    
    UIButton *but1=[UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame= CGRectMake(0, 0, 300, 300);
    [but1 setTitle:@"" forState:UIControlStateNormal];
    [but1 setAlpha:1.0];
    [but1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:but1];
    
    [_imageView addSubview:toolbar];
    
    [_session startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)takePicture:(id)sender {
    CGImageRef cgimg = [self.context createCGImage:ciimg fromRect:[ciimg extent]];
    [lib writeImageToSavedPhotosAlbum:cgimg metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        CGImageRelease(cgimg);
    }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pb = CMSampleBufferGetImageBuffer(sampleBuffer);
    ciimg = [CIImage imageWithCVPixelBuffer:pb];

    // add filter
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:ciimg forKey:@"inputImage"];
   // [filter setValue:@(2.0) forKey:@"inputAngle"];
    CIImage * result = [filter valueForKey:@"outputImage"];

    // show result
    CGImageRef ref = [self.context createCGImage:result fromRect:ciimg.extent];
    _imageView.image = [UIImage imageWithCGImage:ref scale:1.0 orientation:(UIImageOrientationRight)];


    CFRelease(ref);
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end




