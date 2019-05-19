#
# Be sure to run `pod lib lint TFMultiFileUploader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TFMultiFileUploader'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TFMultiFileUploader.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a multi-file upload tool class.
Multi-threading of uploading single file to realize multi-file uploading function
                       DESC

  s.homepage         = 'https://github.com/olafLi/TFMultiFileUploader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olafLi' => 'litf@citycloud.com.cn' }
  s.source           = { :git => 'https://github.com/olafLi/TFMultiFileUploader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TFMultiFileUploader/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3'
end
