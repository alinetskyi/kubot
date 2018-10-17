require "sqlite3"

module Kubot
  class KubotDB < SQLite3::Database
    def create_teams_table
      self.execute <<-SQL
    create table if not exists teams (
    team_id varchar(30),
    team_name varchar(30),
    bot_id varchar(30),
    access_token varchar(50),
    bot_access_token varchar(50),
    UNIQUE(team_id,access_token,bot_access_token)
);
      SQL
    end

    def add_team(team_id, team_name, bot_id, access_token, bot_access_token)
      self.execute("INSERT INTO teams (team_id, team_name,bot_id, access_token, bot_access_token)
                   VALUES (?,?,?,?,?);", [team_id, team_name, bot_id, access_token, bot_access_token])
    end

    def create_channels_table
      self.execute <<-SQL
    create table if not exists channels (
      support_channel varchar(30),
      ask_channel varchar(30),
      support_channel_bot_token varchar(50),
      ask_channel_bot_token varchar(50),
      UNIQUE(support_channel)
    );
      SQL
    end

    def add_channels(support_channel, ask_channel, support_channel_bot_token, ask_channel_bot_token)
      self.execute("INSERT INTO channels (support_channel, ask_channel,support_channel_bot_token, ask_channel_bot_token)
             VALUES (?,?,?,?) ON CONFLICT (support_channel) DO UPDATE SET ask_channel=(?)", [support_channel, ask_channel, support_channel_bot_token, ask_channel_bot_token, ask_channel])
    end

    def update_ask_channel(support_channel,ask_channel)
      self.execute("UPDATE channels SET ask_channel = (?) WHERE support_channel = (?)",[ask_channel,support_channel])
    end

    def select_team_by_name(team_name)
      self.execute("SELECT * FROM teams WHERE team_name = (?)", [team_name]) do |row|
        return row
      end
    end

    def select_team_by_id(team_id)
      self.execute("SELECT * FROM teams WHERE team_id = (?)", [team_id]) do |row|
        return row
      end
    end

    def get_team_bot_token(team_id)
      self.execute("SELECT bot_access_token FROM teams WHERE team_id = (?)", [team_id]) do |row|
        return row
      end
    end

    def get_all_bot_tokens
      bt = Array.new
      self.execute("SELECT bot_access_token FROM teams") do |row|
        bt.push(row)
      end
      return bt
    end

    def get_team_name(team_id)
      self.execute("SELECT team_name FROM teams WHERE team_id = (?)", [team_id]) do |row|
        return row
      end
    end

    def get_team_token(team_id)
      self.execute("SELECT access_token FROM teams WHERE team_id = (?)", [team_id]) do |row|
        return row
      end
    end

    def get_bot_id(team_id)
      self.execute("SELECT bot_id FROM teams WHERE team_id = (?)", [team_id]) do |row|
        return row
      end
    end

    def select_support_channel(ask_channel)
      self.execute("SELECT support_channel FROM channels WHERE ask_channel = (?)", [ask_channel]) do |row|
        return row
      end
    end

    def select_ask_channel(support_channel)
      self.execute("SELECT ask_channel FROM channels WHERE support_channel = (?)", [support_channel]) do |row|
        return row
      end
    end

    def get_channels_table
      self.execute("SELECT * FROM channels ") do |row|
        return row
      end
    end

    def get_ask_bot_token(ask_channel)
      self.execute("SELECT ask_channel_bot_token FROM channels WHERE ask_channel = (?)", [ask_channel]) do |row|
        return row
      end
    end

    def get_support_bot_token(support_channel)
      self.execute("SELECT support_channel_bot_token FROM channels WHERE support_channel = (?)", [support_channel]) do |row|
        return row
      end
    end
  end
end
