# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SimpleFit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleFit
  pod 'SwiftLint'
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
  pod 'SideMenu', '~> 6.0'
  pod 'MIBlurPopup'
  pod 'ADDatePicker', :git => 'https://github.com/alex851209/ADDatePicker.git', :commit => '66e721ef409a7aa9611371b675c21eab9d903a07'
  pod 'IQKeyboardManagerSwift'
  pod "Gemini"
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Kingfisher'
  pod 'ProgressHUD'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
              end
          end
      end
  end
end