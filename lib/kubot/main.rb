module Kubot
  class Main < Clamp::Command
    subcommand "start", "Start the kubot" do
=begin
      option "--token", "TOKEN", "Slack api token",
        :environment_variable => "SLACK_API_TOKEN", :required => true
      option "--channel" "SUPPORT_CHANNEL","Support channel id",
        :environment_variable => "SLACK_SUPPORT_CHANNEL", :required => true
=end
      def execute
        run Auth.run!
      end
    end

    option "--version", :flag, "Show version" do
      puts Kubot::VERSION
      exit(0)
    end

  end
end
