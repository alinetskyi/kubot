require 'clamp'
require 'slack-ruby-bot'
require 'kubot/version'
require 'kubot/bot'
require 'kubot/main'
require 'kubot/server'
require 'sinatra'


module Kubot

  @@teams = Hash.new
  @@team_names = Hash.new
  @@team_ch = Hash.new
  class Web < Sinatra::Base
  get '/' do
  if params.key?('code')
   rc = JSON.parse(HTTP.post('https://slack.com/api/oauth.access', params: {
    client_id: ENV['SLACK_CLIENT_ID'],
    client_secret: ENV['SLACK_CLIENT_SECRET'],
    code: params['code']
   }))
   token = rc['bot']['bot_access_token']
   @@teams[rc['team_id']] = token
   #$teams_ch[rc['team_id']] = rc['access_token']
   @@team_names[rc['team_id']] = rc['access_token']
   team_id = rc['team_id']
   MyServer.new(token: token).start_async

   "Team Successfully Registered token #{token}, team: #{team_id} #{rc['access_token']}"
  else
   "Hello World"
  end
end
  end 
end
