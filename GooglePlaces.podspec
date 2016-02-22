Pod::Spec.new do |s|
  s.name             = "GooglePlaces"
  s.version          = "1.0.4"
  s.summary          = "Swift Wrapper on Google Places API"
  s.description      = <<-DESC
                       Swift Wrapper on Google Places API
                       https://developers.google.com/places/web-service/

                       DESC
  s.homepage         = "https://github.com/honghaoz/Swift-Google-Maps-API"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Swift-Google-Maps-API.git", :tag => s.version.to_s }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc     = true
  s.source_files     = "Source/Core/**/*.*", "Source/Google Places API/**/*.*"
  s.module_name      = "GooglePlaces"
  
  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'ObjectMapper', '~> 1.0'

end
