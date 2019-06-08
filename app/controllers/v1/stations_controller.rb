class V1::StationsController < ApplicationController
  def index
    @stations = Station.all_with_logs

    render json: @stations.to_json
  end
end
