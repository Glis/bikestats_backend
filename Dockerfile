# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/passenger-ruby25

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Essentials (Base packages)
RUN apt-get update -qq && apt-get install --fix-missing --no-install-recommends -y \ 
    build-essential apt-utils apt-transport-https wget gnupg cron htop libffi-dev openssl  \
    libxml2-dev libxslt1-dev nano vim curl ssh libyaml-dev software-properties-common tzdata \
    ca-certificates libgdbm-dev libncurses5-dev automake libtool bison libffi-dev \ 
    libfontconfig1 libxrender1 libxext6 libpq-dev 
    
# Nodejs
RUN wget -qO- https://deb.nodesource.com/setup_8.x  | bash - && \
    apt-get update && \
    apt-get install -y nodejs

# Ruby 2.5.5
RUN bash -lc 'rvm list'
RUN bash -lc 'rvm --default use ruby-2.5.5'

# Rake to enable whenever runners
RUN gem install rake && gem install bundler --no-ri --no-rdoc

# Custom commands
ENV APP_HOME /app

# Essentials (Base packages)
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/ 
RUN bundle install

COPY . $APP_HOME

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*