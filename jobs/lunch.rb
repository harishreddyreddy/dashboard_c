# lunch_options = ['Whole Foods?', 'Cafe Downstairs?', 'Trader Joe?', 'Salesforce cafe?']
#
# SCHEDULER.every '800m', :first_in => 0 do
#   send_event('lunch', {text: lunch_options.sample})
# end