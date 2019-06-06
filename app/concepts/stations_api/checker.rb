class StationsApi::Checker
  API_BASE_URL = "http://api.citybik.es/v2/networks/bikesantiago"

  def self.get_network_info
    response = api_request(API_BASE_URL)

    if response.present?
      puts "#{DateTime.current.localtime('-04:00')}: API CALL: Se han obtenido registros para #{response['network']['stations'].count} estaciones"

      response['network']['stations'].map do |station|
        [
          station['id'],
          {
            name:         station['name'],
            used_bikes:   station['empty_slots'],
            free_bikes:   station['free_bikes'],
            last_updated: station['extra']['last_updated'],
          }
        ]
      end.to_h
    else
      {}
    end
  end

  private

  def self.api_request(url)
    response = RestClient.get(url)

    JSON.parse(response) if response.present?
  end
end