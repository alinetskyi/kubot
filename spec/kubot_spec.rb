RSpec.describe Kubot::Main do

  it "has a version number" do
    expect(Kubot::VERSION).not_to be nil
  end

  it "starts without an error" do
    expect(Kubot::Main.run(File.basename($0),["bin/kubot","start"])).to_not raise_error
  end

  it "has environment set up correctly" do
    expect(Kubot::Main.run(File.basename($0),["bin/kubot","start"])).to_not output("ERROR: you need to set 3 environment variables:\nSLACK_CLIENT_ID\nSLACK_CLIENT_SECRET\nSLACK_SUPPORT_TEAM")
  end

end
