require "spec_helper"

describe Lita::Handlers::Stocks, lita_handler: true do
  it { routes_command("stock GOOG").to(:stock_info) }
  it { doesnt_route_command("stock").to(:stock_info) }

  it "checks default stock" do
    send_command "stock GOOG"
    expect(replies.last).to include("Google Inc")
    expect(replies.last).to include("GOOG")
    expect(replies.last).to include("NASDAQ")
  end
end
