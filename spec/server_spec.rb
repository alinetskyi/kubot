require 'json'
RSpec.describe Kubot::KubotServer do
  
  after do 
    File.delete("kubot.db") if File.exists?("kubot.db")
  end

  it "answers a question without file attachment" do
    data = OpenStruct.new({:channel => 'SUP', :text => 'test'})
    Kubot::Main.db.add_channels("SUP","ASK","SUPTKN","ASKTKN")
    resp = Kubot::KubotServer.answer_question(data)
    expect(resp).not_to be(nil)
  end

end
