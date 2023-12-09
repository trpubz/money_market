require "rails_helper"

RSpec.describe "TomTom Service" do
  describe "requests helpers" do
    before(:each) do
      url = "https://api.tomtom.com/" \
        "search/2/reverseGeocode/" + %w[37.8328 -122.27669].join(",") + ".json" \
        "?key=" + Rails.application.credentials.tomtom

      stub_request(:get, url).to_return(status: 200, body: "{\"data\": \"\"}")
    end

    it "builds a connection" do
      conn = TomTomService.conn
      expect(conn).to be_a Faraday::Connection
    end

    it "builds a valid request" do
      response = TomTomService.lat_lon_json(%w[37.8328 -122.27669])

      expect(response).to be_a Hash
      expect(response[:status]).to eq 200
    end

    it "gets a good response when passing in valid lat lon in array format", :vcr do
      WebMock.allow_net_connect!

      response = TomTomService.atm_json({lat: 37.8328, lon: -122.27669})

      expect(response[:status]).to eq 200
      expect(response[:data]).to be_a Hash
    end

    describe "::lat_lon_from_address" do
      it "returns a lat/lon from a full address using the tom tom geocode endpoint", :vcr do
        # WebMock.allow_net_connect!

        market_params = {
          name: "14&U Farmers' Market",
          street: "1400 U Street NW",
          city: "Washington",
          county: "DC",
          state: "DC"
        }

        mrkt = Market.create(market_params)

        lat, lon = TomTomService.lat_lon_from_address(mrkt.url_encoded_address)

        expect(lat).to be_a String
        expect(lon).to be_a String
      end
    end
  end
end
