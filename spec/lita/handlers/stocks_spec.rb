require "spec_helper"

describe Lita::Handlers::Stocks, lita_handler: true do
  it { routes_command("stock GOOG").to(:stock_info) }
  it { doesnt_route_command("stock").to(:stock_info) }

  it "checks default stock" do
    send_command "stock GOOG"
    expect(replies.last).to include("Google Inc")
    expect(replies.last).to include("GOOG")
    expect(replies.last).to include("NASDAQ")
    expect(replies.last).to include("MktCap")
  end

  it "checks an invalid stock" do
    send_command "stock GOOGFAKE"
    expect(replies.last).to eq("Sorry, but there was a problem retrieving stock information.")
  end

  it "checks a stock without mktcap" do
    send_command "stock .DJI"
    expect(replies.last).to include("Dow Jones Industrial")
    expect(replies.last).to_not include("MktCap")
    expect(replies.last).to_not include("P/E")
  end
end
