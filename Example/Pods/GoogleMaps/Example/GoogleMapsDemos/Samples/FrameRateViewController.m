#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/Samples/FrameRateViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@interface FrameRateViewController ()

@end

@implementation FrameRateViewController {
  GMSMapView *_mapView;
  UITextView *_statusTextView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera =
      [GMSCameraPosition cameraWithLatitude:-33.868 longitude:151.2086 zoom:6];
  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  self.view = _mapView;

  // Add a display for the current frame rate mode.
  _statusTextView = [[UITextView alloc] init];
  _statusTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
  _statusTextView.text = @"";
  _statusTextView.textAlignment = NSTextAlignmentCenter;
  _statusTextView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8f];
  _statusTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _statusTextView.editable = NO;
  [self.view addSubview:_statusTextView];
  [_statusTextView sizeToFit];

  // Add a button toggling through modes.
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                    target:self
                                                    action:@selector(didTapNext)];
  [self updateStatus];
}

- (void)didTapNext {
  _mapView.preferredFrameRate = [self nextFrameRate];
  [self updateStatus];
}

+ (NSString *)nameForFrameRate:(GMSFrameRate)frameRate {
  switch (frameRate) {
    case kGMSFrameRatePowerSave:
      return @"PowerSave";
    case kGMSFrameRateConservative:
      return @"Conservative";
    case kGMSFrameRateMaximum:
      return @"Maximum";
  }
}

- (GMSFrameRate)nextFrameRate {
  switch (_mapView.preferredFrameRate) {
    case kGMSFrameRatePowerSave:
      return kGMSFrameRateConservative;
    case kGMSFrameRateConservative:
      return kGMSFrameRateMaximum;
    case kGMSFrameRateMaximum:
      return kGMSFrameRatePowerSave;
  }
}

- (void)updateStatus {
  _statusTextView.text =
      [NSString stringWithFormat:@"Preferred frame rate: %@",
                                 [self.class nameForFrameRate:_mapView.preferredFrameRate]];
}

@end
