require_relative "../models/atm"

class ATMFacade

  def self.atms(mrkt)
    atms = Rails.cache.read("atms-#{mrkt.id}")

    if atms.nil?
      response = TomTomService.atm_json({ lat: mrkt.lat, lon: mrkt.lon })
      data = response[:data]

      atms = data[:results].map do |result|
        ATM.new(result)
      end

      Rails.cache.write("atms-#{mrkt.id}", atms)
    end

    atms
  end
end
