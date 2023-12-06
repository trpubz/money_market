require "rails_helper"

RSpec.describe "Market Serializer" do
  describe "custom attributes" do
    it "returns the custom attr 'cash-only' based on vendors.credit_accepted" do
      vndrs = create_list(:vendor, 3, {credit_accepted: false})
      mrkt = create :market
      vndrs.each do |vndr|
        MarketVendor.create(market_id: mrkt.id, vendor_id: vndr.id)
      end

      json = MarketSerializer.new(mrkt).to_hash[:data][:attributes]

      expect(json).to have_key :cash_only
    end
  end
end
