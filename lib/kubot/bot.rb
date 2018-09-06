module Kubot
  class Bot < SlackRubyBot::Bot
=begin
  @keywords = Array.new
  
  def self.get_keywords
    File.open(ENV['SLACK_KEYWORDS_FILE_PATH'], "r") do |f|
      f.each_line do |line|
        @keywords.push(line.delete!("\n"))
      end
    end
  end
  
=end
  command 'hi' do |client,data,match|
    client.say(
      channel: data.channel,
      text: "Hi, <@#{data.user}>! How are you doing?",)
  end

  command 'help' do |client,data,match|
    client.say(
      channel: data.channel,
      text: ":spock-hand:\n *I'm a support Kubot*\n_You can either DM me or use any of these commands:_\n•hi\n•help\n•about",
      mrkdwn: true)
  end

  command 'about' do |client,data,match|
    client.say(
      channel: data.channel,
      text: "I'm here to provide you help with any question you have about Peatio or Rubykube stack\nIf you want to get a valuable answer you need to provide a clear and easy to understand question\notherwise I might struggle to undestand you.\nIf you want to know what I can do just type in `help`\nI'm proficient in this list of topics:\n•Peatio\n•Barong\n•Deployment\n•Applogic\n•Trading-UI",
      mrkdwn: true)
  end

    match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)
      def self.call(client, data, _match)
        @keywords = ["peatio","barong","workbench","applogic","trading-ui","docker","currency","cold wallet","hot wallet","authorization","2FA","2fa","cluster","totp"]
          @keywords.each do |keyword|
          if data.text.include? keyword
            client.say(channel: data.channel, text: "Hold on <@#{data.user}> I need to ask one of the specialists! ")
            client.say(channel: ENV['SLACK_SUPPORT_CHANNEL'], text: "#{data.channel}| <@#{data.user}> : #{data.text}")
            return
          end 
          end
            client.say(channel: data.channel, text: "Sorry, I'm not sure I have answer to that question, Could you try to say it differently?")
      end
  end
end

