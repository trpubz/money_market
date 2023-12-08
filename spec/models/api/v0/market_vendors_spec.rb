require "rails_helper"

RSpec.describe Market do
  describe "instance methods" do
    it "has a computed property #vender_count" do
      vendors = create_list(:vendor, 2)
      mrkt = create :market

      vendors.each do |v|
        MarketVendor.create(vendor_id: v.id, market_id: mrkt.id)
      end

      mrkt.reload  # Reload the object to get the updated state from the database

      expect(mrkt.vendor_count).to eq 2
    end
  end
end
