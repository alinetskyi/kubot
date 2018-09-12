require 'sqlite3'

module Kubot
  class KubotDB < SQLite3::Database 
    def create_teams_table
      self.execute <<-SQL
    create table if not exists teams (
    team_id varchar(30),
    team_name varchar(30),
    access_token varchar(50),
    bot_access_token varchar(50),
    UNIQUE(team_id,access_token,bot_access_token)
);
      SQL
    end

    def add_team(team_id,team_name,access_token,bot_access_token)  
      self.execute("INSERT INTO teams (team_id, team_name, access_token, bot_access_token)
                   VALUES (?,?,?,?);",[team_id,team_name,access_token,bot_access_token])
=begin 
                   WHERE NOT EXISTS (select * from teams where team_id = '#{team_id}' 
                   AND team_name = '#{team_name}' 
                   AND access_token='#{access_token}' 
                   AND bot_access_token = '#{bot_access_token}');
=end
    end

    def create_channels_table
      self.execute <<-SQL
    create table if not exists channels (
      support_channel varchar(30),
      ask_channel varchar(30),
      UNIQUE(support_channel,ask_channel)
    );
      SQL
    end

    def add_channels(support_channel,ask_channel)
      self.execute("INSERT INTO channels (support_channel, ask_channel)
             VALUES (?,?) WHERE not exists (select * from channels where support_channel = '#{support_channel} AND ask_channel = '#{ask_channel}')", [support_channel,ask_channel])
    end

    def select_team_by_name(team_name)
      self.execute("SELECT * FROM teams WHERE team_name = '#{team_name}'") do |row|
        return row
      end
    end

    def select_team_by_id(team_id)
      self.execute("SELECT * FROM teams WHERE team_id = '#{team_id}'") do |row|
        return row
      end
    end

    def get_team_bot_token(team_id)
      self.execute("SELECT bot_access_token FROM teams WHERE team_id = '#{team_id}'") do |row| 
        return row
      end
    end

    def get_all_bot_tokens
      tokens = Array.new
      self.execute("SELECT bot_access_token FROM teams") do |row|
        tokens.insert(row)
      end
      return tokens
    end

    def get_team_name(team_id)
      self.execute("Select team_name FROM teams WHERE team_id = '#{team_id}'") do |row|
        return row
      end
    end

    def get_team_token(team_id)
      self.execute("SELECT access_token FROM teams WHERE team_id = '#{team_id}'") do |row| 
        return row
      end
    end

    def select_support_channel(ask_channel)
      self.execute("SELECT support_channel FROM channels WHERE ask_channel = '#{ask_channel}'") do |row|
        return row
      end
    end

    def select_ask_channel(support_channel)
      self.execute("SELECT ask_channel FROM channels WHERE support_channel = '#{support_channel}'") do |row|
        return row
      end
    end
  end
end
