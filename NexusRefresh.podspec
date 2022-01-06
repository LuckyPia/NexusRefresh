#
# Be sure to run `pod lib lint NexusRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NexusRefresh'
  s.version          = '2.0.3'
  s.summary          = 'iOS多页面数据同步刷新'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/LuckyPia/NexusRefresh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LuckyPia' => '664454335@qq.com' }
  s.source           = { :git => 'https://github.com/LuckyPia/NexusRefresh.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'NexusRefresh/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 5.0'
  s.dependency "RxCocoa", "~> 5.0"
end
