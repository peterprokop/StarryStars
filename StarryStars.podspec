Pod::Spec.new do |s|
  s.name = 'StarryStars'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'iOS GUI library for displaying and editing ratings'
  s.homepage = 'https://github.com/peterprokop/StarryStars'
  s.authors = { 'Peter Prokop' => 'prokop.petr@gmail.com' }
  s.source = { :git => 'https://github.com/peterprokop/StarryStars.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = 'true'
  s.source_files = 'StarryStars/*.swift'
  s.resources = [ "StarryStars/Resource/*.*" ]
end
