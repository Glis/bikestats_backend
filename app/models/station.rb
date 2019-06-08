class Station < ApplicationRecord
  has_many :usage_logs

  # Retrieves all stations in json-parseable format
  # Parameters:
  # -type: whether to retieve las hour of usage or last day of usages
  def self.all_with_logs(type = :hour)
    stations = all.includes(:usage_logs).order(name: :asc)

    result = {
      'general': {
        name: 'All',
        id: 'general',
        lastUpdated: 'N/A',
        totalBikes: Station.sum(:total_bikes),
        lastUsedBikes: Station.sum(:latest_used_bikes),
        lastFreeBikes: Station.sum(:latest_free_bikes),
        data: Station.get_all_station_last_logs_sums
      }
    }

    result.merge(stations.map { |station| [station.identifier, station.objectify] }.to_h)
  end

  # Transforms an station instance into an hash object useful for the frontend
  def objectify
    {
      name: name,
      id: identifier,
      lastUpdated: last_updated.iso8601,
      totalBikes: total_bikes,
      lastUsedBikes: latest_used_bikes,
      lastFreeBikes: latest_free_bikes,
      data: last_hour_logs.map { |log| [ log.created_at.beginning_of_minute.to_i, log.used_bikes ] }
    }
  end

  # limits the usage logs sent to the front to the last hour ones
  def last_hour_logs
    usage_logs.limit(60).order(created_at: :desc).reverse
  end

  # Whole Network usage calculator
  # Sums all the results from all the stations into one single array.
  # To-Do: use a better strategy for saving the whole network statistics. maybe a non-relational database
  # or just another table for the network per-se
  def self.get_all_station_last_logs_sums
    reducer_matrix = all.map { |station| station.last_hour_logs.map { |log| [ log.created_at.beginning_of_minute.to_i, log.used_bikes ] } }.transpose

    reducer_matrix.map { |x| [ x[0][0], x.transpose[1].reduce(:+) ] }
  end

  #-------------------------- Cronjob functions ---------------------------------

  # Crontab automatic function. Works each minute to save the latest status of the network
  # Makes a request to the API to save the info in DB for later use.
  def self.update_from_api
    all_station_data = StationsApi::Checker.get_network_info

    all_identifiers = Station.pluck :identifier

    Station.transaction do
      puts "#{DateTime.current.localtime('-04:00')}: ===== Starting to save new logs"
      all_station_data.each do |identifier, station_info|
        if Station.exists?(identifier: identifier)
          puts "#{DateTime.current.localtime('-04:00')}: Station #{identifier} exists. Creating logs"
          Station.find_by(identifier: identifier).update_and_log(station_info)

          all_identifiers.delete identifier
        else
          puts "#{DateTime.current.localtime('-04:00')}: New station! id: #{identifier}"
          Station.create_and_log(identifier, station_info)
        end
      end

      unless all_identifiers.blank?
        puts "#{DateTime.current.localtime('-04:00')}: There are #{all_identifiers.length} stations left out by the API. Registering their logs..."
        all_identifiers.each do |identifier|
          puts "#{DateTime.current.localtime('-04:00')}: Station #{identifier} exists and forgotten. Creating fake logs"
          station = Station.find_by(identifier: identifier)

          station.update_and_log({
            used_bikes:   station.latest_used_bikes,
            free_bikes:   station.latest_free_bikes,
            last_updated: station.last_updated
          })
        end
      end

      puts "#{DateTime.current.localtime('-04:00')}: ===== Log saving finished"
    end
  end

  # Adds a Station and logs the first usage to the system
  def self.create_and_log(identifier, station_info)
    station_attributes = {
        identifier: identifier,
        name: station_info[:name],
        last_updated: Time.zone.at(station_info[:last_updated]),
        total_bikes: station_info[:used_bikes] + station_info[:free_bikes],
        latest_used_bikes: station_info[:used_bikes],
        latest_free_bikes: station_info[:free_bikes]
    }
    station = Station.new(station_attributes)

    station.usage_logs.build(used_bikes: station_info[:used_bikes], free_bikes: station_info[:free_bikes] )

    station.save
  end

  # Updates a Station and logs an usage to the system
  # Updated fields:
  # - last_updated: Timestamps from the API
  # - latest_used_bikes: Counter of unavailable bikes (for the current status of the station)
  # - latest_free_bikes: Counter of available bikes (for the current status of the station)
  def update_and_log(station_info)
    update_attributes(last_updated: Time.zone.at(station_info[:last_updated]),
                      total_bikes: station_info[:used_bikes] + station_info[:free_bikes],
                      latest_used_bikes: station_info[:used_bikes],
                      latest_free_bikes: station_info[:free_bikes])
    usage_logs.create(used_bikes: station_info[:used_bikes], free_bikes: station_info[:free_bikes] )
  end
end
