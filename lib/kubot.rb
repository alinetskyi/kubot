require 'sinatra'
require 'clamp'
require 'slack-ruby-bot'
require 'kubot/version'
require 'kubot/main'
require 'kubot/server'
require 'eventmachine'
require 'kubot/auth'
require 'kubot/db'
require 'kubot/setup'
require 'faye/websocket'
require 'http'
require 'json'

module Kubot
  Main.run
end
