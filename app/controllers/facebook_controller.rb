# require 'koala'
class FacebookController < ApplicationController
  def index
    # koala_oauth = Koala::Facebook::OAuth.new(ENV['facebook_app_id'], ENV['facebook_app_secret'], "http://local.drops.me:3000/")
    # puts koala_oauth
    @graph = Koala::Facebook::API.new(current_user.fbOAuthToken)
    # @response = @graph.put_connections("me", "feed", :message => "bum chik bum bum!")
    # puts @response.length
    # @response.each do |friend|
      # puts friend
    # end
    @response = ''
    friends = @graph.get_connections("me", "friends")
    puts friends.length
    friends.each do |friend|
      puts friens
      @response = @response + friend
    end
    # feed =@graph.get_connections("me", "feed")
    # puts feed.length
    # feed.each do |f|
      # puts f
    # end
    # @groups_list  = []
    # groups = @graph.get_connections("me", "groups").select do |group|
      # @group_list.push(group["name"].downcase)
      # puts group["name"].downcase 
    # end
  end
end