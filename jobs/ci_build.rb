SCHEDULER.every '20s', :first_in => 0  do

  tray = CCTray.new(ENV['CI_USER_NAME'], ENV['CI_PASSWORD'])
  projects = tray.fetch

branche_names = {'coupa_development (master)' => 'master',
            'coupa_development (012_release)' => 'r12',
            'coupa_development (012_release_unit_tests)' => 'r12_unit',
            'coupa_development (011_release)' => 'r11',
            'coupa_development (012_0_8_release)' => '12_0_8',
            'coupa_development (011_0_21_release)' => '11_0_21'}

  result_override = {'master' => false, 'r12'=> false, 'r12_unit'=> false,
                     'r11' => false, '12_0_8' => false, '11_0_21' => false}

  projects.each do |project|
      send_event(branche_names[project.name], {
        currentResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status,
        lastResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status ,
        timestamp: project.last_build_time_str,
        message: branche_names[project.name] =~ /12_0_/ ? 'Unit & integration tests' : '' ,
        value: 0
      })
  end
end

