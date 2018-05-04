
Pod::Spec.new do |s|
  s.name         = "ZHAlertController2"
  s.version      = "1.0.5"
  s.summary      = "可以很方便的调用系统的UIAlertController"
  s.homepage     = "https://github.com/josercc/ZHAlertController"
  s.license      = "MIT"
  s.author       = { "josercc" => "josercc@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/josercc/ZHAlertController.git", :tag => "#{s.version}" }
  s.vendored_framework  = "Carthage/Build/iOS/ZHAlertController.framework"
  s.prepare_command = "/usr/local/bin/carthage update --platform ios"
end
