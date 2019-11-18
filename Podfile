platform :ios, '10.0'
source 'https://github.com/CocoaPods/Specs.git'

def install_pods
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RealmSwift'
  pod 'Firebase/Analytics'
  pod 'CalculateCalendarLogic'
  
  pod 'PKHUD'
  
  pod 'FSCalendar'
  pod 'Charts'
  
  pod 'Pring'
  pod 'Muni'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
end

target 'Ecomane' do
  install_pods
end


swift3_names = [
]

swift4_names = [

]

swift42_names = [
]

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if swift4_names.include? target.name
        config.build_settings['SWIFT_VERSION'] = "4.0"
        elsif swift42_names.include? target.name
        config.build_settings['SWIFT_VERSION'] = "4.2"
        elsif swift3_names.include? target.name
        config.build_settings['SWIFT_VERSION'] = "3.0"
        else
        config.build_settings['SWIFT_VERSION'] = "5.0"
      end
    end
  end
end
