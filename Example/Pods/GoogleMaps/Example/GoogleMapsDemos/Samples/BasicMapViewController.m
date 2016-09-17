#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/Samples/BasicMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@interface BasicMapViewController () <GMSMapViewDelegate>
@end

@implementation BasicMapViewController {
  UILabel *_statusLabel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                          longitude:151.2086
                                                               zoom:6];
  GMSMapView *view = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  view.delegate = self;
  self.view = view;

  // Add status label, initially hidden.
  _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
  _statusLabel.alpha = 0.0f;
  _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _statusLabel.backgroundColor = [UIColor blueColor];
  _statusLabel.textColor = [UIColor whiteColor];
  _statusLabel.textAlignment = NSTextAlignmentCenter;

  [view addSubview:_statusLabel];
}

- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView {
  _statusLabel.alpha = 0.8f;
  _statusLabel.text = @"Rendering";
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
  _statusLabel.alpha = 0.0f;
}

@end
