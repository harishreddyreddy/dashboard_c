SCHEDULER.every '20s', :first_in => 0  do

  tray = CCTray.new(ENV['CI_USER_NAME'], ENV['CI_PASSWORD'])
  projects = tray.fetch

branche_names = {'coupa_development (master)' => 'Master',
            'coupa_development (012_release)' => 'R12',
            'coupa_development (012_release_unit_tests)' => 'R12 Unit',
            'coupa_development (011_release)' => 'R11',
            'coupa_development (012_0_4_release)' => 'R12_0_4',
            'coupa_development (011_0_17_release)' => 'R11_0_17'}

  result_override = {'Master' => false, 'R12'=> false, 'R12 Unit'=> false,
                     'R11' => false, 'R12_0_4' => false, 'R11_0_17' => false}

  projects.each do |project|
      send_event(branche_names[project.name], {
        currentResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status,
        lastResult: result_override[branche_names[project.name]] ?  'Override' : project.last_build_status ,
        timestamp: project.last_build_time_str,
        message: branche_names[project.name] == 'R12_0_4' ? 'Unit & integration tests' : '' ,
        value: 0
      })
  end
end

