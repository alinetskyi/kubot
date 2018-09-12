module Kubot
=begin
  $channels = Hash.new
  $teams = Hash.new
  $team_channel = Hash.new
=end
  class Auth < Sinatra::Base
    def self.set_credentials(rc)
      #$teams[rc['team_id']] = [rc['team_name'],rc['access_token'],rc['bot']['bot_access_token']]
      $db.add_team(rc['team_id'],rc['team_name'],rc['access_token'],rc['bot']['bot_access_token'])
    end 
    get '/' do
      if params.key?('code')
        rc = JSON.parse(HTTP.post('https://slack.com/api/oauth.access', params: {
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: params['code']
        }))
        Auth.set_credentials(rc)
        token = rc['bot']['bot_access_token']
        #$teams[rc['team_id']] = token
        #$team_names[rc['team_id']] = rc['access_token']
        team_id = rc['team_id']
        MyServer.new(token: token).start_async
        "Team Successfully Registered #{rc} token #{token}, team: #{team_id}"
      else
        "Hello World"
      end
    end
  end
end
