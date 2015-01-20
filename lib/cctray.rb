require 'net/http'
require 'net/https'
require 'nokogiri'
require 'pry'

class CCTray

  class Project < Struct.new(:name,
                             :activity,
                             :last_build_status,
                             :last_build_label,
                             :last_build_time_str,
                             :web_url,
                             :messages)
    def last_build_time
      @last_build_time ||= DateTime.parse(last_build_time_str) if last_build_time_str
    end
  end
  class Message < Struct.new(:kind, :text)
  end

  def initialize(user=nil, pass=nil)
    @feed_url = ENV['CI_FEED']
    @user, @pass = user, pass
  end

  def fetch
    builds = Nokogiri::XML(get).css("Project").select { |project| ['011_release_fox' ,'012_release_fox', 'master_fox', '012_release_unit_tests', '011_0_14_release', '012_0_2_release'].any? { |w| project['name'] =~ /#{w}/ } }

    builds.map do |branch|
      Project.new(branch[:name],
                  branch[:activity],
                  branch[:lastBuildStatus],
                  branch[:lastBuildLabel],
                  branch[:lastBuildTime],
                  branch[:webUrl])
    end
  end

  def get
    uri = URI(@feed_url)
    http_opts = { use_ssl: uri.scheme == 'https' }
    Net::HTTP.start uri.host, uri.port, http_opts do |https|
      req = Net::HTTP::Get.new(uri.path).tap do |req|
        req.basic_auth @user, @pass if @user
      end

      case res = https.request(req)
        when Net::HTTPSuccess
          res.body
        else
          res.error!
      end
    end
  end
end