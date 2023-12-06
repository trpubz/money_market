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
      response = TomTomService.get(
        "search/2/reverseGeocode/" + %w[37.8328 -122.27669].join(",") + ".json"
      )

      expect(response).to be_a Faraday::Response
      expect(response.status).to eq 200
    end

    it "gets a good response when passing in valid lat lon in array format" do
      response = TomTomService.lat_lon_json(%w[37.8328 -122.27669])

      expect(response[:status]).to eq 200
      expect(response[:data]).to eq({data: ""})
    end
  end
end