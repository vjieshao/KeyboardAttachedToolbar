#
#  Be sure to run `pod spec lint BLAPIManagers.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "KeyboardAttachedToolbar"
  s.version      = "0.0.2"
  s.summary      = "KeyboardAttachedToolbar."
  
  s.description  = <<-DESC
                    this is KeyboardAttachedToolbar
                   DESC
                   
  s.homepage     = "https://github.com/vjieshao/KeyboardAttachedToolbar"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author             = { "vjieshao" => 'vhuangj@gmail.com' }

  s.ios.deployment_target = "10.0"
  
  s.source       = { :git => "https://github.com/vjieshao/KeyboardAttachedToolbar.git", :tag => s.version }
  s.source_files = "KeyboardAttachedToolbar/**/*.swift"

  s.requires_arc = true

  s.swift_version = '5.0'
  
  s.dependency "KeyboardMan"
  s.dependency "SnapKit"

end
