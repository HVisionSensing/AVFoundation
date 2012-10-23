//
//  ViewController.h
//  AVFoundationDemo
//
//  Created by TangQiao on 12-10-16.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface ViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>{
    @private
        UIImageView *toolbar;
        CIImage *ciimg;
    
       ALAssetsLibrary *lib;
}
- (IBAction)takePicture:(id)sender;
@end
