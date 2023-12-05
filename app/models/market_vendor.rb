class MarketVendor < ApplicationRecord
  validates :market_id,
    uniqueness: {
      scope: :vendor_id,
      message: "and vendor combination must be unique"
    }
  belongs_to :market
  belongs_to :vendor

  # after_save :update_vendor_count_in_market
  # after_destroy :update_vendor_count_in_market
  #
  # private
  #
  # def update_vendor_count_in_market
  #   market.update(vendor_count: market.vendors.count)
  # end
end
