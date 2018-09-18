RSpec.describe Kubot::KubotDB do
  before(:all) do
    @db = Kubot::KubotDB.new "test.db"
    @team = ["TEAM1","team","BOT1","ACTKN","BTACTKN"]
    @channels = ["supp","ask","supptok","asktok"]
  end

  after(:all) do
    File.delete("/home/r1c2/work/kubot/test.db") if File.exist?("/home/r1c2/work/kubot/test.db")
  end

  it "creates team table" do
    columns, rows = @db.create_teams_table
    puts columns,rows
    expect(columns.nil?).to be(true)
    expect(rows.nil?).to be(true)
  end

  it "creates channels table" do
    columns,rows = @db.create_channels_table
    expect(columns.nil?).to be(true)
    expect(rows.nil?).to be(true)
  end

  it "adds a team " do
    @db.add_team(@team[0],@team[1],@team[2],@team[3],@team[4])
    expect(@db.select_team_by_id("TEAM1")).to eq(@db.select_team_by_name("team")) 
  end

  it "adds a channel" do
    @db.add_channels(@channels[0],@channels[1],@channels[2],@channels[3])
    expect(@db.select_ask_channel("supp")[0].to_s).to eq(@db.select_ask_channel(@db.select_support_channel("ask")[0].to_s)[0].to_s)
  end

  it "selects team by name" do
    expect(@db.select_team_by_name("team")).to eq(@team)
  end

  it "selects team by id" do
    expect(@db.select_team_by_id("TEAM1")).to eq(@team)
  end

  it "gets team bot token with team id " do
    expect(@db.get_team_bot_token("TEAM1")[0].to_s).to eq(@team[4])
  end

  it "gets all bots tokens" do
    expect(@db.get_all_bot_tokens[0][0].to_s).to eq(@team[4])
  end

  it "gets team name with team id" do
    expect(@db.get_team_name(@team[0])[0].to_s).to eq(@team[1])
  end

  it "gets team token with team id" do
    expect(@db.get_team_token(@team[0])[0].to_s).to eq(@team[3])
  end

  it 'gets bot id with team id' do
    expect(@db.get_bot_id(@team[0])[0].to_s).to eq(@team[2])
  end
  it 'gets support channel id with ask channel id' do
    expect(@db.select_support_channel(@channels[1])[0].to_s).to eq(@channels[0])
  end

  it 'gets ask channel id with support id' do
    expect(@db.select_ask_channel(@channels[0])[0].to_s).to eq(@channels[1])
  end

  it 'outputs the whole channels table' do
    expect(@db.get_channels_table).to eq(@channels)
  end

  it 'gets ask bot token with ask channel id' do
    expect(@db.get_ask_bot_token("ask")[0].to_s).to eq(@channels[3])
  end

  it 'gets support bot token with support channel id' do
    expect(@db.get_support_bot_token("supp")[0].to_s).to eq(@channels[2])
  end

end

