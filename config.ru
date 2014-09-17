require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application

use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == ENV['DASHBOARD_AUTH_USERNAME'] && password == ENV['DASHBOARD_AUTH_PASSWORD']
end