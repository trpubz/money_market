require "rails_helper"

RSpec.describe Market do
  describe "instance methods" do
    describe "#cash_only" do
      context "all vendors do NOT accept credit" do
        it "returns true" do
          vndrs = create_list(:vendor, 3, {credit_accepted: false})
          mrkt = create :market
          vndrs.each do |vndr|
            MarketVendor.create(market_id: mrkt.id, vendor_id: vndr.id)
          end

          expect(mrkt.cash_only).to eq true
        end
      end

      context "at least one vendor accepts credit" do
        it "returns false" do
          vndrs = create_list(:vendor, 3, {credit_accepted: true})
          mrkt = create :market
          vndrs.each do |vndr|
            MarketVendor.create(market_id: mrkt.id, vendor_id: vndr.id)
          end

          expect(mrkt.cash_only).to eq false
        end
      end
    end
  end
end
