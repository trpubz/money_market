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

      expect(market).to have_key(:title)
      expect(market[:title]).to be_a(String)

      expect(market).to have_key(:author)
      expect(market[:author]).to be_a(String)

      expect(market).to have_key(:genre)
      expect(market[:genre]).to be_a(String)

      expect(market).to have_key(:summary)
      expect(market[:summary]).to be_a(String)

      expect(market).to have_key(:number_sold)
      expect(market[:number_sold]).to be_an(Integer)
    end
  end

  it "can get one market by its id" do
    id = create(:market).id

    get "/api/v0/markets/#{id}"

    market = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(market).to have_key(:id)
    expect(market[:id]).to eq(id)

    expect(market).to have_key(:title)
    expect(market[:title]).to be_a(String)

    expect(market).to have_key(:author)
    expect(market[:author]).to be_a(String)

    expect(market).to have_key(:genre)
    expect(market[:genre]).to be_a(String)

    expect(market).to have_key(:summary)
    expect(market[:summary]).to be_a(String)

    expect(market).to have_key(:number_sold)
    expect(market[:number_sold]).to be_an(Integer)
  end

  it "can create a new market" do
    market_params = {
      title: "Murder on the Orient Express",
      author: "Agatha Christie",
      genre: "mystery",
      summary: "Filled with suspense.",
      number_sold: 432
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/markets", headers: headers, params: JSON.generate(market: market_params)
    created_market = Market.last

    expect(response).to be_successful
    expect(created_market.title).to eq(market_params[:title])
    expect(created_market.author).to eq(market_params[:author])
    expect(created_market.summary).to eq(market_params[:summary])
    expect(created_market.genre).to eq(market_params[:genre])
    expect(created_market.number_sold).to eq(market_params[:number_sold])
  end

  it "can update an existing market" do
    id = create(:market).id
    previous_name = Market.last.title
    market_params = {title: "Charlotte's Web"}
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v0/markets/#{id}", headers: headers, params: JSON.generate({market: market_params})
    market = Market.find_by(id: id)

    expect(response).to be_successful
    expect(market.title).to_not eq(previous_name)
    expect(market.title).to eq("Charlotte's Web")
  end

  it "can destroy an market" do
    market = create(:market)

    expect { delete "/api/v0/markets/#{market.id}" }.to change(Market, :count).by(-1)

    expect { Market.find(market.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
