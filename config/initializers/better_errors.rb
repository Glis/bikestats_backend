if defined? BetterErrors
  # Vagrant
  # if ENV['SSH_CLIENT']
  #   trusted_ip = ENV['SSH_CLIENT'].split(' ').first
  #   # puts "=> better_errors is open for #{trusted_ip}"
  #   BetterErrors::Middleware.allow_ip! trusted_ip
  # end

  # Docker y Docker-compose
  BetterErrors::Middleware.allow_ip! '10.0.0.0/8'
  BetterErrors::Middleware.allow_ip! '172.16.0.0/12'
  BetterErrors::Middleware.allow_ip! '192.168.0.0/1'
end