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
