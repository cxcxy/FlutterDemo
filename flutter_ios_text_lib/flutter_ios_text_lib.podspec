#
# Be sure to run `pod lib lint flutter_ios_text_lib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'flutter_ios_text_lib'
  s.version          = '0.1.0'
  s.summary          = 'A short description of flutter_ios_text_lib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/897939354@qq.com/flutter_ios_text_lib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '897939354@qq.com' => '897939354@qq.com' }
  s.source           = { :git => 'https://github.com/897939354@qq.com/flutter_ios_text_lib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'flutter_ios_text_lib/Classes/**/*'
  s.static_framework = true
    # s.source_files = 'flutter-lib/Classes/**/*'
  s.ios.vendored_frameworks = 'ios_frameworks/App.framework', 'ios_frameworks/Flutter.framework', 'ios_frameworks/FlutterPluginRegistrant.framework', 'ios_frameworks/Pods_Runner.framework', 'ios_frameworks/flutter_boost.framework'

  # s.resource_bundles = {
  #   'flutter_ios_text_lib' => ['flutter_ios_text_lib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
