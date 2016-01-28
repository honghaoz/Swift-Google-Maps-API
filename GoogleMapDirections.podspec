Pod::Spec.new do |s|
  s.name             = "GoogleMapDirections"
  s.version          = "1.0"
  s.summary          = "Swift Wrapper on Google Map Directions API"
  s.description      = <<-DESC
                       Swift Wrapper on Google Map Directions API

                       DESC
  s.homepage         = "https://github.com/honghaoz/Swift-Google-Maps-Directions-API"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/Swift-Google-Maps-Directions-API.git", :tag => s.version.to_s }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.requires_arc     = true
  s.module_name      = "GoogleMapDirections"
  s.dependency 

  s.default_subspecs = 'Alamofire', '~> 3.0'
  s.default_subspecs = 'ObjectMapper', '~> 1.0'

end
