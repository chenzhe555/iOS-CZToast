Pod::Spec.new do |s|
  s.name         = "CZToast"
  s.version      = "0.0.1"
  s.summary      = "iOS-Toast"
  s.description  = "iOS-Toast类"
  s.homepage     = "https://github.com/chenzhe555/iOS-CZToast"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "chenzhe555" => "376811578@qq.com" }
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/chenzhe555/iOS-CZToast.git", :tag => "#{s.version}" }
  s.subspec 'CZToast' do |one|
      one.source_files = 'CZToast/classes/*.{h,m}'
  end
  # s.frameworks = "SomeFramework", "AnotherFramework"
  # s.libraries = "iconv", "xml2"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
end
