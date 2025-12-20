#!/bin/bash

# iOS Flavor Setup Script for Flutter
# This script creates Dev and Prod configurations and schemes in Xcode

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_ROOT=$(pwd)
IOS_DIR="$PROJECT_ROOT/ios"
RUNNER_DIR="$IOS_DIR/Runner"

echo -e "${GREEN}Starting iOS Flavor Setup...${NC}\n"

# Step 2: Generate launcher icons
echo -e "${YELLOW}Generating launcher icons...${NC}"
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml
echo -e "${GREEN}✓ Icons generated${NC}\n"

# Step 3: Create Flutter directory and AppFrameworkInfo.plist
echo -e "${YELLOW}Creating Flutter directory and AppFrameworkInfo.plist...${NC}"
mkdir -p "$IOS_DIR/Flutter"

cat > "$IOS_DIR/Flutter/AppFrameworkInfo.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>App</string>
  <key>CFBundleIdentifier</key>
  <string>io.flutter.flutter.app</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>App</string>
  <key>CFBundlePackageType</key>
  <string>FMWK</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleSignature</key>
  <string>????</string>
  <key>CFBundleVersion</key>
  <string>1.0</string>
  <key>MinimumOSVersion</key>
  <string>12.0</string>
</dict>
</plist>
EOF

echo -e "${GREEN}✓ AppFrameworkInfo.plist created${NC}\n"

# Step 3: Create configuration files for Dev and Prod in ios/Flutter
echo -e "${YELLOW}Creating Dev and Prod configuration files...${NC}"

# Dev Configs
cat > "$IOS_DIR/Flutter/Debug-Dev.xcconfig" << 'EOF'
#include "Debug.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug-dev.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault.dev
PRODUCT_NAME = PassVault-Dev
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-dev
EOF

cat > "$IOS_DIR/Flutter/Release-Dev.xcconfig" << 'EOF'
#include "Release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release-dev.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault.dev
PRODUCT_NAME = PassVault-Dev
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-dev
EOF

cat > "$IOS_DIR/Flutter/Profile-Dev.xcconfig" << 'EOF'
#include "Release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile-dev.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault.dev
PRODUCT_NAME = PassVault-Dev
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-dev
EOF

# Prod Configs
cat > "$IOS_DIR/Flutter/Debug-Prod.xcconfig" << 'EOF'
#include "Debug.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug-prod.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault
PRODUCT_NAME = PassVault
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-prod
EOF

cat > "$IOS_DIR/Flutter/Release-Prod.xcconfig" << 'EOF'
#include "Release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release-prod.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault
PRODUCT_NAME = PassVault
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-prod
EOF

cat > "$IOS_DIR/Flutter/Profile-Prod.xcconfig" << 'EOF'
#include "Release.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile-prod.xcconfig"

PRODUCT_BUNDLE_IDENTIFIER = com.dhruvanbhalara.passvault
PRODUCT_NAME = PassVault
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-prod
EOF

echo -e "${GREEN}✓ Configuration files created${NC}\n"

# Step 4: Create schemes and build configurations using Ruby script
echo -e "${YELLOW}Creating Xcode configurations and schemes...${NC}"

cat > "$IOS_DIR/create_schemes.rb" << 'RUBYEOF'
require 'xcodeproj'

project_path = 'Runner.xcodeproj'

unless File.exist?(project_path)
  puts "Error: #{project_path} not found!"
  exit 1
end

project = Xcodeproj::Project.open(project_path)

# Get the Runner target
target = project.targets.find { |t| t.name == 'Runner' }
unless target
  puts "Error: Runner target not found!"
  exit 1
end

configurations = ['Dev', 'Prod']

configurations.each do |flavor|
  ['Debug', 'Release', 'Profile'].each do |base_config|
    config_name = "#{base_config}-#{flavor}"
    xcconfig_name = "#{config_name}.xcconfig"
    
    # Find or create file reference in Flutter group
    flutter_group = project.main_group['Flutter']
    file_ref = flutter_group.files.find { |f| f.path == "Flutter/#{xcconfig_name}" }
    unless file_ref
      file_ref = flutter_group.new_file("Flutter/#{xcconfig_name}")
    end

    # Add to Project Level
    unless project.build_configurations.any? { |bc| bc.name == config_name }
      base_bc = project.build_configurations.find { |bc| bc.name == base_config }
      new_config = project.add_build_configuration(config_name, base_bc ? base_bc.type : (base_config == 'Debug' ? :debug : :release))
      if base_bc
        new_config.build_settings = base_bc.build_settings.dup
      end
      new_config.base_configuration_reference = file_ref
      # Remove overrides to let .xcconfig take precedence
      new_config.build_settings.delete('PRODUCT_NAME')
      new_config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
      new_config.build_settings.delete('ASSETCATALOG_COMPILER_APPICON_NAME')
      puts "Created project configuration: #{config_name}"
    else
      config = project.build_configurations.find { |bc| bc.name == config_name }
      config.base_configuration_reference = file_ref
      config.build_settings.delete('PRODUCT_NAME')
      config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
      config.build_settings.delete('ASSETCATALOG_COMPILER_APPICON_NAME')
      puts "Updated project configuration: #{config_name}"
    end

    # Add to Target Level (all targets)
    project.targets.each do |t|
      unless t.build_configurations.any? { |bc| bc.name == config_name }
        base_bc = t.build_configurations.find { |bc| bc.name == base_config }
        new_config = t.add_build_configuration(config_name, base_bc ? base_bc.type : (base_config == 'Debug' ? :debug : :release))
        if base_bc
          new_config.build_settings = base_bc.build_settings.dup
        end
        new_config.base_configuration_reference = file_ref
        new_config.build_settings.delete('PRODUCT_NAME')
        new_config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
        new_config.build_settings.delete('ASSETCATALOG_COMPILER_APPICON_NAME')
        puts "Created target configuration for #{t.name}: #{config_name}"
      else
        config = t.build_configurations.find { |bc| bc.name == config_name }
        config.base_configuration_reference = file_ref
        config.build_settings.delete('PRODUCT_NAME')
        config.build_settings.delete('PRODUCT_BUNDLE_IDENTIFIER')
        config.build_settings.delete('ASSETCATALOG_COMPILER_APPICON_NAME')
        puts "Updated target configuration for #{t.name}: #{config_name}"
      end
    end
  end

  # Create scheme if it doesn't exist
  scheme_name = flavor
  unless Xcodeproj::XCScheme.shared_data_dir(project_path).join("#{scheme_name}.xcscheme").exist?
    scheme = Xcodeproj::XCScheme.new
    scheme.add_build_target(target)
    
    scheme.launch_action.build_configuration = "Debug-#{flavor}"
    scheme.test_action.build_configuration = "Debug-#{flavor}"
    scheme.profile_action.build_configuration = "Profile-#{flavor}"
    scheme.analyze_action.build_configuration = "Debug-#{flavor}"
    scheme.archive_action.build_configuration = "Release-#{flavor}"
    
    scheme.save_as(project_path, scheme_name)
    puts "Created scheme: #{scheme_name}"
  end
end

project.save
puts "Build configurations and schemes created successfully!"
RUBYEOF

# Step 6: Install xcodeproj gem if not installed
echo -e "${YELLOW}Checking for xcodeproj gem...${NC}"
if ! gem list xcodeproj -i > /dev/null 2>&1; then
    echo -e "${YELLOW}Installing xcodeproj gem...${NC}"
    sudo gem install xcodeproj
fi

# Run the Ruby script
cd "$IOS_DIR"
ruby create_schemes.rb
cd "$PROJECT_ROOT"

echo -e "${GREEN}✓ Xcode configurations and schemes created${NC}\n"

# Step 7: Create Podfile with proper configuration
echo -e "${YELLOW}Updating Podfile...${NC}"

cat > "$IOS_DIR/Podfile" << 'EOF'
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
  'Debug-Dev' => :debug,
  'Debug-Prod' => :debug,
  'Release-Dev' => :release,
  'Release-Prod' => :release,
  'Profile-Dev' => :release,
  'Profile-Prod' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
EOF

echo -e "${GREEN}✓ Podfile updated${NC}\n"

# Step 8: Install pods
echo -e "${YELLOW}Installing CocoaPods dependencies...${NC}"
cd "$IOS_DIR"
pod deintegrate
pod install
cd "$PROJECT_ROOT"

echo -e "${GREEN}✓ Pods installed${NC}\n"

# Step 9: Final instructions
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}iOS Flavor Setup Complete!${NC}"
echo -e "${GREEN}======================================${NC}\n"

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "1. Open Xcode: ${GREEN}open ios/Runner.xcworkspace${NC}"
echo -e "2. Select the Runner project in the project navigator"
echo -e "3. Select the Runner target"
echo -e "4. Go to 'Build Settings' and search for 'User-Defined'"
echo -e "5. Add the following configurations manually if needed:"
echo -e "   - PRODUCT_BUNDLE_IDENTIFIER for each configuration"
echo -e "   - PRODUCT_NAME for each configuration\n"

echo -e "${YELLOW}To run your app with flavors:${NC}"
echo -e "Dev:  ${GREEN}flutter run --flavor dev -t lib/main.dart${NC}"
echo -e "Prod: ${GREEN}flutter run --flavor prod -t lib/main.dart${NC}\n"

echo -e "${YELLOW}Update your bundle identifiers in:${NC}"
echo -e "- ios/Runner/Configuration/Dev/Dev.xcconfig"
echo -e "- ios/Runner/Configuration/Prod/Prod.xcconfig\n"

echo -e "${GREEN}Done!${NC}"