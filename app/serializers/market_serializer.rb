class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip

  attribute :vendor_count do |obj|
    obj.vendor_count
  end

  attribute :cash_only do |obj|
    obj.cash_only
  end

  def self.format_market(market)
    {
      id: market.id.to_s,
      name: market.name,
      street: market.street,
      city: market.city,
      county: market.county,
      state: market.state,
      zip: market.zip,
      vendor_count: market.vendor_count,
      cash_only: market.cash_only
    }
  end
end
