Pod::Spec.new do |s|
  s.name             = "GoogleMapsDirections"
  s.version          = "1.1.2"
  s.summary          = "Swift Wrapper on Google Maps Directions API"
  s.description      = <<-DESC
                       Swift Wrapper on Google Maps Directions API
                       https://developers.google.com/maps/documentation/directions/intro

                       DESC
  s.homepage         = "https://github.com/honghaoz/Swift-Google-Maps-API"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Swift-Google-Maps-API.git", :tag => s.version.to_s }

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc     = true
  s.source_files     = "Source/Core/**/*.*", "Source/Google Maps Directions API/**/*.*"
  s.module_name      = "GoogleMapsDirections"

  s.dependency 'Alamofire', '~> 4'
  s.dependency 'ObjectMapper', '~> 2'

end
