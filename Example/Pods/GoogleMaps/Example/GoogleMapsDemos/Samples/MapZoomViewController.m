#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/Samples/MapZoomViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation MapZoomViewController {
  GMSMapView *_mapView;
  UITextView *_zoomRangeView;
  NSUInteger _nextMode;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                          longitude:151.2086
                                                               zoom:6];
  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _mapView.settings.scrollGestures = NO;
  self.view = _mapView;

  // Add a display for the current zoom range restriction.
  _zoomRangeView = [[UITextView alloc] init];
  _zoomRangeView.frame =
      CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
  _zoomRangeView.text = @"";
  _zoomRangeView.textAlignment = NSTextAlignmentCenter;
  _zoomRangeView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8f];
  _zoomRangeView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _zoomRangeView.editable = NO;
  [self.view addSubview:_zoomRangeView];
  [_zoomRangeView sizeToFit];
  [self didTapNext];

  // Add a button toggling through modes.
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                    target:self
                                                    action:@selector(didTapNext)];
}

- (void)didTapNext {
  NSString *label = @"";
  float minZoom = kGMSMinZoomLevel;
  float maxZoom = kGMSMaxZoomLevel;

  switch (_nextMode) {
    case 0:
      label = @"Default";
      break;
    case 1:
      minZoom = 18;
      label = @"Zoomed in";
      break;
    case 2:
      maxZoom = 8;
      label = @"Zoomed out";
      break;
    case 3:
      minZoom = 10;
      maxZoom = 11.5;
      label = @"Small range";
      break;
  }
  _nextMode = (_nextMode + 1) % 4;

  [_mapView setMinZoom:minZoom maxZoom:maxZoom];
  _zoomRangeView.text =
      [NSString stringWithFormat:@"%@ (%.2f - %.2f)", label, _mapView.minZoom, _mapView.maxZoom];
}

@end
