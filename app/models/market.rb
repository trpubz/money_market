class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end

  def self.search(attrs)
    markets = Market.all

    attrs.each do |k, v|
      markets = markets.where("#{k} ILIKE ?", "%#{v}%")
    end

    markets
  end

  def cash_only
    !vendors.any? { |v| v.credit_accepted }
  end
end
