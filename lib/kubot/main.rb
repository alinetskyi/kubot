module Kubot
  SLACK_CLIENT_ID = ENV["SLACK_CLIENT_ID"]
  SLACK_CLIENT_SECRET = ENV["SLACK_CLIENT_SECRET"]
  SLACK_SUPPORT_TEAM = ENV["SLACK_SUPPORT_TEAM"]
  class Main < Clamp::Command
    subcommand "start", "Start the kubot" do
      
      def execute
        if SLACK_CLIENT_ID != nil && SLACK_CLIENT_SECRET != nil && SLACK_SUPPORT_TEAM != nil 
          Setup.run
          run Auth.run!
        else
          puts "ERROR: you need to set 3 environment variables:\nSLACK_CLIENT_ID\nSLACK_CLIENT_SECRET\nSLACK_SUPPORT_TEAM"
          exit(1)
        end
      end
    end

    option "--version", :flag, "Show version" do
      puts Kubot::VERSION
      exit(0)
    end

  end
end
