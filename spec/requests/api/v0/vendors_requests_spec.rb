require "rails_helper"

RSpec.describe "vendors requests" do
  describe "#show" do
    context "good request" do
      it "returns good json of vendor" do
        vndr = create :vendor

        get "/api/v0/vendors/#{vndr.id}"

        vendor = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(vendor[:id]).to eq vndr.id.to_s
        expect(vendor[:type]).to eq "vendor"
        expect(vendor[:attributes][:name]).to eq vndr.name
        expect(vendor[:attributes][:description]).to eq vndr.description
        expect(vendor[:attributes][:contact_name]).to eq vndr.contact_name
        expect(vendor[:attributes][:contact_phone]).to eq vndr.contact_phone
        expect(vendor[:attributes][:credit_accepted]).to eq vndr.credit_accepted
      end
    end

    context "bad request" do
      it "returns 404 message" do
        id = "123123123123123"
        get "/api/v0/vendors/#{id}"

        msg = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status :not_found
        expect(msg[:errors]).to eq "Not Found"
      end
    end
  end

  describe "#create" do
    context "good data" do
      it "creates new AR model and returns JSON object" do
        data = {
          name: "Buzzy Bees",
          description: "local honey and wax products",
          contact_name: "Berly Couwer",
          contact_phone: "8389928383",
          credit_accepted: false
        }.to_json

        post api_v0_vendors_path, params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:created)
        expect(response.body).to include("Buzzy Bees")
      end
    end

    context "bad data" do
      it "returns a 400 and error message" do
        data = {
          name: "Buzzy Bees",
          description: "local honey and wax products"
        }.to_json

        post api_v0_vendors_path, params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("Validation failed")
      end
    end
  end

  describe "#delete" do
    context "good data" do
      it "delete AR model and returns 204" do
        vndr = create :vendor
        id = vndr.id

        delete "/api/v0/vendors/#{id}"

        expect(response).to have_http_status(:no_content)

        get "/api/v0/vendors/#{id}"

        expect(response).to have_http_status :not_found
      end

      context "bad data" do
        it "returns 404 if id doesn't exists" do
          delete "/api/v0/vendors/01234664987"

          expect(response).to have_http_status :not_found
          expect(response.body).to include "Couldn't find Vendor"
        end
      end
    end

    context "bad data" do
      it "returns a 400 and error message" do
        data = {
          name: "Buzzy Bees",
          description: "local honey and wax products"
        }.to_json

        post api_v0_vendors_path, params: data, headers: {"content-type": "application/json"}

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to include("Validation failed")
      end
    end
  end
end
