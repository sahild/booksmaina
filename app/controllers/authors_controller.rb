class AuthorsController < ApplicationController
  def index
    @authors = Author.all.order("title").paginate(:page => params[:page], :per_page => 10)
  end
  
  def findByName
    puts params[:author_name]
    title = params[:author_name].gsub("-"," ").gsub("_",".")
    puts title
    @author = Author.find_by_title(title)
    @books = @author.books
    render "books"
  end
end