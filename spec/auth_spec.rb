require 'json'

RSpec.describe Kubot::Auth do

  it "sets corecct credentials for the team" do
    rc = { 'team_id' => '123',
      'team_name' => 'tesname',
      'bot' => {'bot_user_id' => 'B321',
    'bot_access_token' => 'bottoken21321'},
      'access_token' => 'actoken23213'}
    expect(Kubot::Auth.set_credentials(rc.to_json)).to be(true) 
  end

  it "rejects incorrect credentials" do 
    rc  = {"taem_id" => '21321', 
    "team_name" => 'ewqewq'}
    expect(Kubot::Auth.set_credentials(rc.to_json)).to be(false)
  end

end

