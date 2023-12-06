require "faraday"

class TomTomService
  def self.lat_lon_json(lat_lon)
    response = conn.get("search/2/reverseGeocode/" + lat_lon.join(",") + ".json")

    response_conversion(response)
  end

  # @param geo: a hash with lat: and lon: keys
  def self.atm_json(geo)
    response = conn.get("search/2/categorySearch/automatic%20teller%20machines.json") do |req|
      req.params.merge!(
        "lat" => geo[:lat],
        "lon" => geo[:lon]
      )
    end

    response_conversion(response)
  end

  def self.conn
    # https://{baseURL}/search/{versionNumber}/reverseGeocode/{position}.{ext}?key={Your_API_Key}&returnSpeedLimit={returnSpeedLimit}&heading={heading}&radius={radius}&number={number}&returnRoadClass={returnRoadClass}&returnRoadUse={returnRoadUse}&roadUse={roadUse}&entityType={entityType}&callback={callback}&language={language}&allowFreeformNewline={allowFreeformNewline}&returnMatchType={returnMatchType}&view={view}&mapcodes={mapcodes}&filter={filter}
    Faraday.new("https://api.tomtom.com/") do |con|
      con.params["key"] = Rails.application.credentials.tomtom
    end
  end

  def self.response_conversion(response)
    {status: response.status, data: JSON.parse(response.body, symbolize_names: true)}
  end
end
