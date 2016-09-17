#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/Samples/GestureControlViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation GestureControlViewController {
  GMSMapView *_mapView;
  UISwitch *_zoomSwitch;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];

  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _mapView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:_mapView];

  UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 59)];
  holder.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  holder.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8f];
  [self.view addSubview:holder];

  // Zoom label.
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 200, 29)];
  label.text = @"Zooming?";
  label.font = [UIFont boldSystemFontOfSize:18.0f];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.layer.shadowColor = [[UIColor whiteColor] CGColor];
  label.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
  label.layer.shadowOpacity = 1.0f;
  label.layer.shadowRadius = 0.0f;
  [holder addSubview:label];

  // Control zooming.
  _zoomSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(-90, 16, 0, 0)];
  _zoomSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  [_zoomSwitch addTarget:self
                  action:@selector(didChangeZoomSwitch)
        forControlEvents:UIControlEventValueChanged];
  _zoomSwitch.on = YES;
  [holder addSubview:_zoomSwitch];
}

- (void)didChangeZoomSwitch {
  _mapView.settings.zoomGestures = _zoomSwitch.isOn;
}

@end
