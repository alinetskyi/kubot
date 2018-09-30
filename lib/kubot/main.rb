module Kubot
  SLACK_CLIENT_ID = ENV["SLACK_CLIENT_ID"]
  SLACK_CLIENT_SECRET = ENV["SLACK_CLIENT_SECRET"]
  SLACK_SUPPORT_TEAM = ENV["SLACK_SUPPORT_TEAM"]

  class Main < Clamp::Command
    subcommand "start", "Start the kubot" do
      def execute
        %W{SLACK_CLIENT_ID SLACK_CLIENT_SECRET SLACK_SUPPORT_TEAM }.each do |env_var|
          if ENV[env_var] == '' || ENV[env_var].nil?
            puts "ERROR: "+ env_var+" is not set!"
            exit(1)
          end
        end

          @@db = KubotDB.new "kubot.db"
          @@db.create_channels_table
          @@db.create_teams_table
            begin
              bots = @@db.get_all_bot_tokens
              puts bots
              bots.each do |bot|
                MyServer.new(token: bot[0].to_s).start_async
              end
            rescue
              return nil
            end
          run Auth.run!
      end
    end


    class << self
      def db
        @@db
      end
    end

    option "--version", :flag, "Show version" do
      puts Kubot::VERSION
      exit(0)
    end
  end
end
