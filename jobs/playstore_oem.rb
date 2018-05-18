#!/usr/bin/env ruby
require 'rubygems'
require 'market_bot'

SCHEDULER.every '4h', :first_in => 0 do |job|
  data = {
    :last_version => {
      average_rating: 0.0,
      voters_count: 0
    }
  }
  begin
    config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/playstore_oem.yml'
    config = YAML::load(File.open(config_file))
    app = MarketBot::Play::App.new(config['app_identifier'])
    app.update
    data[:last_version][:average_rating] = app.rating
    if config['show_detail_rating']
      rating_detail = 0.0
      number_of_votes = 0
      app.rating_distribution.each { |rating_distribution|
        rating_detail += rating_distribution[0] * rating_distribution[1]
        number_of_votes += rating_distribution[1]
      }
      if number_of_votes > 0
        rating_detail = "%.4f" % (rating_detail / number_of_votes)
      end
      data[:last_version][:average_rating_detail] = rating_detail
    end
    data[:last_version][:voters_count] = app.votes
  rescue Exception => e
    puts "Error: #{e}"
  end

  if defined?(send_event)
    send_event('playstore_oem', data)
  end

end
