require "faraday"

class TomTomService
  def self.lat_lon_json(lat_lon)
    response = get("search/2/reverseGeocode/" + lat_lon.join(",") + ".json")

    {status: response.status, data: JSON.parse(response.body, symbolize_names: true)}
  end

  def self.get(query)
    conn.get(query)
  end

  def self.conn
    # https://{baseURL}/search/{versionNumber}/reverseGeocode/{position}.{ext}?key={Your_API_Key}&returnSpeedLimit={returnSpeedLimit}&heading={heading}&radius={radius}&number={number}&returnRoadClass={returnRoadClass}&returnRoadUse={returnRoadUse}&roadUse={roadUse}&entityType={entityType}&callback={callback}&language={language}&allowFreeformNewline={allowFreeformNewline}&returnMatchType={returnMatchType}&view={view}&mapcodes={mapcodes}&filter={filter}
    Faraday.new("https://api.tomtom.com/") do |con|
      con.params["key"] = Rails.application.credentials.tomtom
    end
  end
end
