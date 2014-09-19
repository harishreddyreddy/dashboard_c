#!/usr/bin/ruby
require 'octokit'
require 'net/http'
require 'json'
require 'base64'
require 'pp'

GITHUB_REPOSITORY = ENV['GITHUB_REPOSITORY']

client = Octokit::Client.new(:access_token => ENV['GIT_ACCESS_TOKEN'])
user = client.user
user.login


SCHEDULER.every '20s', :first_in => 0 do

  branches = ['master', '012_release', '011_release', 'automation', 'master_rails_3_1_official']


  pull_request_per_branch_count = branches.map do |branch|
    row = {
        :label => branch,
        :value => client.pull_requests(GITHUB_REPOSITORY, '', base: branch, per_page: 200, :state => 'open').count
    }
  end
  send_event('pull_requests',  { items: pull_request_per_branch_count })

end
