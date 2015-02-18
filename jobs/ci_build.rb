SCHEDULER.every '20s', :first_in => 0  do

  tray = CCTray.new(ENV['CI_USER_NAME'], ENV['CI_PASSWORD'])
  projects = tray.fetch

branche_names = {'coupa_development (master_fox)' => 'Master',
            'coupa_development (012_release_fox)' => 'R12',
            'coupa_development (012_release_unit_tests)' => 'R12 Unit',
            'coupa_development (011_release_fox)' => 'R11',
            'coupa_development (011_0_14_release)' => 'R11_0_14',
            'coupa_development (012_0_2_release)' => 'R12_0_2'}

  result_override = {'Master' => true, 'R12'=> true, 'R12 Unit'=> true,
                     'R11' => false, 'R11_0_14' => false, 'R12_0_2' => false}

  projects.each do |project|
      send_event(branche_names[project.name], {
        currentResult: result_override[branche_names[project.name]] ?  'Success' : project.last_build_status,
        lastResult: result_override[branche_names[project.name]] ?  'Success' : project.last_build_status ,
        timestamp: project.last_build_time_str,
        value: 0
      })
  end
end

