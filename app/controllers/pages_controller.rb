class PagesController < ApplicationController
  def home
    # marvel query params
    timestamp = Time.now.to_i.to_s
    privateKey = ENV["PRIVATE_KEY"] || "1234"
    publicKey = ENV["PUBLIC_KEY"] || "1234"
    hash = Digest::MD5.hexdigest(timestamp + privateKey + publicKey).to_s

    # picking a random story from hawkeye
    characterId = 1009338
    response = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories", query: { characters: characterId, apikey: publicKey, ts: timestamp, hash: hash})
    stories = JSON.parse(response.body, object_class: OpenStruct)
    story = stories.data&.results&.sample

    # error handling
    if (response.code != 200)
      return
    end

    # new request to fetch characters thumbnails
    response = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories/#{story.id}/characters", query: { apikey: publicKey, ts: timestamp, hash: hash})
    characters = JSON.parse(response.body, object_class: OpenStruct)

    # assign values to view
    @story = story
    @characters = characters.data&.results
    @attribution = stories.attributionHTML
  end
end
