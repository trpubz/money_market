class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon

  attribute :vendor_count do |obj|
    obj.vendor_count
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
      lat: market.lat,
      lon: market.lon,
      vendor_count: market.vendor_count
    }
  end
end
