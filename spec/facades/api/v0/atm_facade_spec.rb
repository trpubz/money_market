require "rails_helper"
require_relative "../../../../app/facades/atm_facade"

RSpec.describe "ATM Facade" do
  describe "class methods" do
    describe "::atms" do
      it "receives a Market model and handles the request/response and caching", :vcr do
        market_params = {
          name: "14&U Farmers' Market",
          street: "1400 U Street NW",
          city: "Washington",
          county: "DC",
          state: "DC"
        }

        mrkt = Market.create(market_params)

        atms = ATMFacade.atms(mrkt)

        expect(atms).to be_an Array
        expect(atms.first).to be_an ATM
      end
    end
  end
end
