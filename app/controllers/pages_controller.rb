class PagesController < ApplicationController
  def home
    storyId = 1024
    timestamp = Time.now.to_i.to_s 
    hash = Digest::MD5.hexdigest(timestamp + ENV["PRIVATE_KEY"] + ENV["PUBLIC_KEY"]).to_s
    response = HTTParty.get("https://gateway.marvel.com:443/v1/public/stories/#{storyId}", query: { apikey: ENV["PUBLIC_KEY"], ts: timestamp, hash: hash})
    @story = response["data"]["results"].first
    characters = []
    @story["characters"]["items"].each do |character|
      response = HTTParty.get(character["resourceURI"], query: { apikey: ENV["PUBLIC_KEY"], ts: timestamp, hash: hash})
      thumbnail = response["data"]["results"].first["thumbnail"]
      character["thumbnail"] = thumbnail["path"] + "." + thumbnail["extension"]
      characters.push(character)
    end
    @characters = characters
    @attribution = response["attributionHTML"]
  end
end
