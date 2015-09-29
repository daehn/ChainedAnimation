
Pod::Spec.new do |s|
  s.name             = "ChainedAnimation"
  s.version          = "2.0.1"
  s.summary          = "ChainedAnimation is a small library to chain multiple animations with different delays."
  s.homepage         = "https://github.com/daehn/ChainedAnimation"
  s.license          = 'MIT'
  s.author           = { "Silvan Dähn" => "silvandaehn@me.com" }
  s.source           = { :git => "https://github.com/daehn/Chain.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/silvandaehn'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ChainedAnimation' => ['Pod/Assets/*.png']
  }

end
