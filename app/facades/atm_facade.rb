require_relative "../models/atm"

class ATMFacade
  def self.atms(mrkt)
    atms = Rails.cache.read("atms-#{mrkt.id}")

    if atms.nil?
      lat, lon = TomTomService.lat_lon_from_address(mrkt.url_encoded_address)
      response = TomTomService.atm_json({lat: lat, lon: lon})
      data = response[:data]

      atms = data[:results].map do |result|
        ATM.new(result)
      end

      Rails.cache.write("atms-#{mrkt.id}", atms)
    end

    atms
  end
end
