require "rails_helper"

describe "Markets API" do
  it "sends a list of markets" do
    create_list(:market, 3)

    get "/api/v0/markets"

    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets.count).to eq(3)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_a(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_nil
    end
  end

  it "can get one market by its id" do
    id = create(:market).id

    MarketVendor.create(vendor: create(:vendor), market_id: id)
    Market.last.reload

    get "/api/v0/markets/#{id}"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(market).to have_key(:id)
    expect(market[:id]).to eq(id)

    expect(market).to have_key(:name)
    expect(market[:name]).to be_a(String)

    expect(market).to have_key(:street)
    expect(market[:street]).to be_a(String)

    expect(market).to have_key(:city)
    expect(market[:city]).to be_a(String)

    expect(market).to have_key(:county)
    expect(market[:county]).to be_a(String)

    expect(market).to have_key(:state)
    expect(market[:state]).to be_a(String)

    expect(market).to have_key(:zip)
    expect(market[:zip]).to be_a(String)

    expect(market).to have_key(:lat)
    expect(market[:lat]).to be_an(String)

    expect(market).to have_key(:lon)
    expect(market[:lon]).to be_an(String)

    expect(market).to have_key(:vendor_count)
    expect(market[:vendor_count]).to be_an(Integer)
  end

  it "can create a new market" do
    market_params = {
      name: "14&U Farmers' Market",
      street: "1400 U Street NW ",
      city: "Washington",
      county: "DC",
      state: "DC",
      lat: "38.9169984",
      lon: "-77.0320505"
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/markets", headers: headers, params: JSON.generate(market: market_params)
    created_market = Market.last

    expect(response).to be_successful
    expect(created_market.name).to eq(market_params[:name])
    expect(created_market.street).to eq(market_params[:street])
    expect(created_market.county).to eq(market_params[:county])
    expect(created_market.city).to eq(market_params[:city])
    expect(created_market.state).to eq(market_params[:state])
    expect(created_market.zip).to eq(market_params[:zip])
    expect(created_market.lat).to eq(market_params[:lat])
    expect(created_market.lon).to eq(market_params[:lon])
  end

  it "can update an existing market" do
    id = create(:market).id
    previous_name = Market.last.name
    market_params = {name: "Year-Round Cedar City Farmer's Market"}
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v0/markets/#{id}", headers: headers, params: JSON.generate({market: market_params})
    market = Market.find_by(id: id)

    expect(response).to be_successful
    expect(market.name).to_not eq(previous_name)
    expect(market.name).to eq("Year-Round Cedar City Farmer's Market")
  end

  it "can destroy an market" do
    market = create(:market)

    expect { delete "/api/v0/markets/#{market.id}" }.to change(Market, :count).by(-1)

    expect { Market.find(market.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
