class PagesController < ApplicationController
  def home
    # marvel query params
    timestamp = Time.now.to_i.to_s
    privateKey = ENV["PRIVATE_KEY"] || "1234"
    publicKey = ENV["PUBLIC_KEY"] || "1234"
    hash = Digest::MD5.hexdigest(timestamp + privateKey + publicKey).to_s

    # picking a random story from hawkeye
    characterId = 1009338
    storyResponse = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories", query: { characters: characterId, apikey: publicKey, ts: timestamp, hash: hash})
    @story = storyResponse["data"]["results"].sample
    storyId = @story["id"]

    # error handling
    if (storyResponse["code"] != 200)
      return
    end

    # new request to fetch characters thumbnails
    charactersResponse = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories/#{storyId}/characters", query: { apikey: publicKey, ts: timestamp, hash: hash})

    # assign values to view
    @characters = charactersResponse["data"]["results"]
    @attribution = storyResponse["attributionHTML"]
  end
end
