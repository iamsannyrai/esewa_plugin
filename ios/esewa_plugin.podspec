#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint esewa_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'esewa_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Esewa plugin for flutter application.'
  s.description      = <<-DESC
Esewa plugin for flutter application.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.preserve_paths = 'EsewaSDK.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework EsewaSDK' }
  s.vendored_frameworks = 'EsewaSDK.framework'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
