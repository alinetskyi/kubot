module Kubot
  class Auth < Sinatra::Base
    def self.set_credentials(rc)
      begin
        Main.db.add_team(rc["team_id"], rc["team_name"], rc["bot"]["bot_user_id"], rc["access_token"], rc["bot"]["bot_access_token"])
        return true
      rescue
        return false
      end
    end
    get "/" do
      if params.key?("code")
        auth_resp = JSON.parse(HTTP.post("https://slack.com/api/oauth.access", params: {
                                                                          client_id: ENV["SLACK_CLIENT_ID"],
                                                                          client_secret: ENV["SLACK_CLIENT_SECRET"],
                                                                          code: params["code"],
                                                                        }))
        if Auth.set_credentials(auth_resp)
          token = auth_resp["bot"]["bot_access_token"]
          MyServer.new(token: token).start_async
          "Team Successfully Registered!"
        else
          "Sorry, this team is already registered!"
        end
      else
        File.read(File.join('src','index.html'))
      end
    end
  end
end
