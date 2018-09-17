RSpec.describe Kubot::KubotDB do 
  before(:all) do 
    @db = Kubot::KubotDB.new "test.db"
  end

  after(:all) do 
    @db.close
  end
  
  it "creates team table" do 
    columns, rows = @db.create_teams_table
    puts columns,rows
    expect(columns.nil?).to be(true)
    expect(rows.nil?).to be(true)
  end

  it "creates channels table" do 
  
  end
  
  it "adds a team " do 
  end

  it "adds a channel" do 

  end
  
  it "selects team by name" do

  end

  it "selects team by id" do 
  end

  it "gets team bot token with team id " do 

  end

  it "gets all bots tokens" do 


  end
  
  it "gets team name with team id" do 

  
  end

  it "gets team token with team id" do

  end

  it 'gets bot id with team id' do
    
  end  
  it 'gets support channel id with ask channel id' do
    
  end

  it 'gets ask channel id with support id' do
    
  end

  it 'outputs the whole channels table' do
    
  end

  it 'gets ask bot token with ask channel id' do
    
  end

  it 'gets support bot token with support channel id' do
    
  end

end

