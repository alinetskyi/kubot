module Kubot
  class Setup
    def self.run 
      @@db = KubotDB.new "new3.db" 
      @@db.create_channels_table
      @@db.create_teams_table
      @@db.add_channels('FAJEW','DSMA')
      @@db.select_ask_channel('FAJEW')
    end
  end
end


