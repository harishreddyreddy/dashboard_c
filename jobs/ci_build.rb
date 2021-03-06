SCHEDULER.every '20s', :first_in => 0  do

  tray = CCTray.new(ENV['CI_USER_NAME'], ENV['CI_PASSWORD'])
  projects = tray.fetch

branche_names = {'coupa_development (master)' => 'master',
            'coupa_development (013_release)' => '013_release',
            'coupa_development (013_0_1_release)' => '13_0_1',
            'coupa_development (012_release)' => 'r12',
            'coupa_development (011_release)' => 'r11',
            'coupa_development (012_0_13_release)' => '12_0_13',
            'coupa_development (011_0_22_release)' => '11_0_22'}

  result_override = {'master' => true, 'r12'=> false, '12_0_13' => false, '13_0_1' => false,
                     'r11' => false, '12_0_11' => false, '11_0_22' => false, '013_release' => false}

  projects.each do |project|
      send_event(branche_names[project.name], {
        currentResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status,
        lastResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status ,
        timestamp: project.last_build_time_str,
        value: 0
      })
  end
end

