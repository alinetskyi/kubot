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
require 'http'
require 'json'
require 'kubot/bot'
require 'faye/websocket'

module Kubot
  Main.run
end
