#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GoogleMapsDemos/Samples/GeocoderViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation GeocoderViewController {
  GMSMapView *_mapView;
  GMSGeocoder *_geocoder;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                          longitude:151.2086
                                                               zoom:12];

  _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  _mapView.delegate = self;

  _geocoder = [[GMSGeocoder alloc] init];

  self.view = _mapView;
}

- (void)mapView:(GMSMapView *)mapView
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
  // On a long press, reverse geocode this location.
  GMSReverseGeocodeCallback handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
    GMSAddress *address = response.firstResult;
    if (address) {
      NSLog(@"Geocoder result: %@", address);

      GMSMarker *marker = [GMSMarker markerWithPosition:address.coordinate];

      marker.title = [[address lines] firstObject];
      if ([[address lines] count] > 1) {
        marker.snippet = [[address lines] objectAtIndex:1];
      }

      marker.appearAnimation = kGMSMarkerAnimationPop;
      marker.map = _mapView;
    } else {
      NSLog(@"Could not reverse geocode point (%f,%f): %@",
            coordinate.latitude, coordinate.longitude, error);
    }
  };
  [_geocoder reverseGeocodeCoordinate:coordinate completionHandler:handler];
}

@end
