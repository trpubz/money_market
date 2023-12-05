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
end
