require "rails_helper"
require_relative "../../app/facades/atm_facade"

RSpec.describe "ATM Facade" do
  describe "class methods" do
    describe "::atms" do
      it "receives a Market model and handles the request/response and caching", :vcr do
        mrkt = create(:market, lat: 33.73143, lon: -112.23536)  # fix the geoloc to avoid unique requests

        atms = ATMFacade.atms(mrkt)

        expect(atms).to be_an Array
        expect(atms.first).to be_an ATM
      end
    end
  end
end
