platform :ios, '10.0'

target 'MyWeight' do
  use_frameworks!

  target 'MyWeightTests' do
    inherit! :search_paths
    inhibit_all_warnings!

    pod 'SwiftGen', '~>6.0'
    pod 'Nimble'
    pod 'Quick'
    pod 'Nimble-Snapshots'
  end

  target 'MyWeightUITests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = 5.0
    end
  end
end
