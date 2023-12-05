require "rails_helper"

RSpec.describe "market vendors requests" do
  describe "#create" do
    context "good data" do
      it "creates new AR model and returns JSON object and 201 created status" do
        vndr = create :vendor
        mrkt = create :market

        data = {
          market_id: mrkt.id.to_s,
          vendor_id: vndr.id.to_s
        }.to_json

        post "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:created)

        get api_v0_market_vendors_path(mrkt)

        expect(response.body).to include vndr.name.to_s
      end
    end

    context "bad data" do
      it "returns a 404 not found if invalid id passed" do
        vndr = create :vendor
        mrkt = create :market

        data = {
          market_id: mrkt.id.to_s,
          vendor_id: "abc01234656"
        }.to_json

        post "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:not_found)

        expect(response.body).to include("Validation failed: Vendor must exist")
      end

      it "returns 400 bad request if ids not present" do
        vndr = create :vendor
        mrkt = create :market

        data = {
          market_id: mrkt.id.to_s,
          vendor_id: ""
        }.to_json

        post "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:bad_request)
      end

      it "returns 422 unprocessable_entity if a MarketVendor object exists for the market and vendor pair" do
        mrkt_vndr = create :market_vendor

        data = {
          market_id: mrkt_vndr.market_id.to_s,
          vendor_id: mrkt_vndr.vendor_id.to_s
        }.to_json

        post "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#delete" do
    context "good data" do
      it "delete AR model and returns 204 no content" do
        mrkt_vndr = create :market_vendor
        mrkt = create :market

        data = {
          market_id: mrkt_vndr.market_id.to_s,
          vendor_id: mrkt_vndr.vendor_id.to_s
        }.to_json

        delete "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:no_content)

        get api_v0_market_vendors_path(mrkt)

        expect(response).to have_http_status :ok
      end
    end

    context "bad data" do
      it "returns a 404 not found if ids are bad" do
        mrkt_vndr = create :market_vendor
        mrkt = create :market

        data = {
          market_id: "123456789",
          vendor_id: mrkt_vndr.vendor_id.to_s
        }.to_json

        delete "/api/v0/market_vendors", params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
