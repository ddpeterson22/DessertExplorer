source 'https://cdn.cocoapods.org'

platform :ios, '16.0'
use_frameworks!

# Yep.
inhibit_all_warnings!

target 'DessertExplorer' do
  # Normal libraries.
  pod 'Alamofire', '~> 5'

  target 'DessertExplorerTests' do
    inherit! :search_paths
    pod 'Quick', '~> 3'
    pod 'Nimble', '~> 9'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.5.8'
    end
  end
end
