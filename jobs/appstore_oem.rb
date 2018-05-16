#!/usr/bin/env ruby
require 'json'
require 'httpclient'

# Get info from the App Store of your App:
# Last version Average and Voting
# All time Average and Voting
#
# This job will track average vote score and number of votes
# of your App by scraping the App Store website.

# Config
OEM_APP_ID = '367722531'
OEM_APP_COUNTRY = 'fr'

client = HTTPClient.new
lastNBVotes = 0
currentNBVotes = 0

SCHEDULER.every '5m', :first_in => 0 do |job|
  time = Time.new

  ratings_res = client.get("http://itunes.apple.com/lookup?id=#{OEM_APP_ID}&country=#{OEM_APP_COUNTRY}")

  data = {
    :last_version => {
      version_number: 0.0,
      average_rating: 0.0,
      voters_count: 0,
      votes_diff: 0,
      :reviews => {
        :first => {
          author: "",
          rating: 0,
          version: 0.0,
          title: "",
          description: ""
        },
        :second => {
          author: "",
          rating: 0,
          version: 0.0,
          title: "",
          description: ""
        },
        :last => {
          author: "",
          rating: 0,
          version: 0.0,
          title: "",
          description: ""
        }
      }
    },
    :all_versions => {
      application_code: "",
      average_rating: 0.0,
      voters_count: 0,
      last_update: 0
    }
  }

  if ratings_res.status != 200
    puts "App Store store website communication (status-code: #{ratings_res.status})\n#{ratings_res.content}"
  else

    ratings_result = JSON.parse(ratings_res.content)['results'][0]

    lastNBVotes = currentNBVotes
    currentVersionVotes = ratings_result['userRatingCountForCurrentVersion']
    diffVotes = currentNBVotes - lastNBVotes;

    data[:last_version][:version_number] = ratings_result['version']
    data[:last_version][:average_rating] = ratings_result['averageUserRatingForCurrentVersion']
    data[:last_version][:voters_count] = ratings_result['userRatingCountForCurrentVersion']
    data[:last_version][:votes_diff] = diffVotes
    data[:all_versions][:average_rating] = ratings_result['averageUserRating']
    data[:all_versions][:voters_count] = ratings_result['userRatingCount']
    data[:all_versions][:last_update] = time

    if data[:last_version][:average_rating] == nil
      data[:last_version][:average_rating] = "None"
    end

    if data[:last_version][:voters_count] == nil
      data[:last_version][:voters_count] = "0"
    end

  end

  reviews_res = client.get("https://itunes.apple.com/#{OEM_APP_COUNTRY}/rss/customerreviews/id=#{OEM_APP_ID}/sortBy=mostRecent/json")

  if reviews_res.status != 200
    puts "App Store store website communication (status-code: #{reviews_res.status})\n#{reviews_res.content}"
  else
    reviews_result = JSON.parse(reviews_res.content)['feed']['entry']

    data[:last_version][:reviews][:first][:author] = reviews_result[1]['author']['name']['label']
    data[:last_version][:reviews][:first][:rating] = reviews_result[1]['im:rating']['label']
    data[:last_version][:reviews][:first][:version] = reviews_result[1]['im:version']['label']
    data[:last_version][:reviews][:first][:title] = reviews_result[1]['title']['label']
    data[:last_version][:reviews][:first][:description] = reviews_result[1]['content']['label']

    data[:last_version][:reviews][:second][:author] = reviews_result[2]['author']['name']['label']
    data[:last_version][:reviews][:second][:rating] = reviews_result[2]['im:rating']['label']
    data[:last_version][:reviews][:second][:version] = reviews_result[2]['im:version']['label']
    data[:last_version][:reviews][:second][:title] = reviews_result[2]['title']['label']
    data[:last_version][:reviews][:second][:description] = reviews_result[2]['content']['label']

    data[:last_version][:reviews][:last][:author] = reviews_result[3]['author']['name']['label']
    data[:last_version][:reviews][:last][:rating] = reviews_result[3]['im:rating']['label']
    data[:last_version][:reviews][:last][:version] = reviews_result[3]['im:version']['label']
    data[:last_version][:reviews][:last][:title] = reviews_result[3]['title']['label']
    data[:last_version][:reviews][:last][:description] = reviews_result[3]['content']['label']

  end

  send_event('appstore_oem', data)

end
