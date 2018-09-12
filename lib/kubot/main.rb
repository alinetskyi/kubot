module Kubot
  SLACK_CLIENT_ID = ENV["SLACK_CLIENT_ID"]
  SLACK_CLIENT_SECRET = ENV["SLACK_CLIENT_SECRET"]
  SLACK_SUPPORT_TEAM = ENV["SLACK_SUPPORT_TEAM"]
  class Main < Clamp::Command
    subcommand "start", "Start the kubot" do
      option "--id", "SLACK_CLIENT_ID", "Slack app client id",
        :environment_variable => "SLACK_CLIENT_ID", :required => true
      option "--secret" "SLACK_CLIENT_SECRET","Slack app client secret",
        :environment_variable => "SLACK_CLIENT_SECRET", :required => true
      option "--support-team" "SLACK_SUPPORT_TEAM", "Slack bot support team",
        :environment_variable => "SLACK_SUPPORT_TEAM", :required => true
      def execute
        if SLACK_CLIENT_ID != nil && SLACK_CLIENT_SECRET != nil && SLACK_SUPPORT_TEAM != nil 
          Setup.run
          run Auth.run!
        else
          puts "ERROR: you need to set 3 environment variables:\nSLACK_CLIENT_ID\nSLACK_CLIENT_SECRET\nSLACK_SUPPORT_TEAM"
        end
      end
    end

    option "--version", :flag, "Show version" do
      puts Kubot::VERSION
      exit(0)
    end

  end
end
