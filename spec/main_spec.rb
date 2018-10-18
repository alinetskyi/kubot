require 'timeout'

RSpec.describe Kubot::Main do

  it "has a version number" do
    expect(Kubot::VERSION).not_to be nil
  end

  it "doesn't run without envs" do
    expect {Kubot::Main.run(File.basename($0),["start"])}.to raise_error(RuntimeError, /ERROR: .* is not set!/)
  end

  it "starts without error" do
    ENV['SLACK_CLIENT_ID'] = 'id'
    ENV['SLACK_CLIENT_SECRET'] = 'secret'
    ENV['SLACK_SUPPORT_TEAM'] = 'team'
    expect { Timeout::timeout(2) {
        Kubot::Main.run(File.basename($0),["start"])
    }}.to raise_exception(Timeout::Error)
  end

  it "creates kubot.db" do
      expect(File.exist?("kubot.db")).to be(true)
  end

  it "creates channels and teams tables" do
      res = %x[sqlite3 kubot.db .tables]
      expect(res).to include('channels','teams')
      File.delete("kubot.db") if File.exist?("test.db")
  end
end
