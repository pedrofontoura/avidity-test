class PagesController < ApplicationController
  def home
    # my chosen story
    storyId = 1024

    # marvel query params
    timestamp = Time.now.to_i.to_s
    privateKey = ENV["PRIVATE_KEY"] || "1234"
    publicKey = ENV["PUBLIC_KEY"] || "1234"
    hash = Digest::MD5.hexdigest(timestamp + privateKey + publicKey).to_s
    
    # send request to marvel api
    response = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories/#{storyId}", query: { apikey: publicKey, ts: timestamp, hash: hash})
    
    # error handling
    if (response["code"] != 200)
      return
    end

    # get story object from response and assign to view
    @story = response["data"]["results"].first

    # new request to fetch characters thumbnails
    characters = []
    @story["characters"]["items"].each do |character|
      response = HTTParty.get(character["resourceURI"], query: { apikey: publicKey, ts: timestamp, hash: hash})
      thumbnail = response["data"]["results"].first["thumbnail"]
      character["thumbnail"] = thumbnail["path"] + "." + thumbnail["extension"]
      characters.push(character)
    end

    # assign values to view
    @characters = characters
    @attribution = response["attributionHTML"]
  end
end
