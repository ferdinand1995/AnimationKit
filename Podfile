# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'AnimationKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for AnimationKit
  pod 'XCoordinator', '~> 2.0'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Moya', '~> 15.0'
  
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      if config.name.include?("Debug")
        config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
  end
end
