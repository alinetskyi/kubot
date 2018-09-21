require 'kubot/version'
require 'kubot/main'
require 'kubot/server'
require 'kubot/auth'
require 'kubot/db'
require 'kubot/setup'
require 'kubot/bot'
require 'sinatra'
require 'clamp'
require 'slack-ruby-bot'
require 'eventmachine'
require 'http'
require 'json'
require 'faye/websocket'

module Kubot
  Main.run
end
