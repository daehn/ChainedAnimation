
Pod::Spec.new do |s|
  s.name             = "ChainedAnimation"
  s.version          = "3.0.0"
  s.summary          = "ChainedAnimation is a small Swift library to chain multiple animations with different delays."
  s.homepage         = "https://github.com/daehn/ChainedAnimation"
  s.license          = 'MIT'
  s.author           = { "Silvan Dähn" => "silvandaehn@me.com" }
  s.source           = { :git => "https://github.com/daehn/ChainedAnimation.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/silvandaehn'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

  s.source_files = "ChainedAnimation", "ChainedAnimation/**/*.{h,m,swift}"
end
