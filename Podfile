platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'Tile Bazar' do
  
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'AssetsPickerViewController'
  pod 'Toast-Swift', '~> 4.0.0'
  pod 'FirebaseCore'
  pod 'FirebaseDynamicLinks'
  pod 'Firebase/Messaging'
  pod 'Siren', :git => 'https://github.com/ArtSabintsev/Siren.git', :branch => 'swift3.2'
  pod 'Alamofire', '4.9.1'
  
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end
