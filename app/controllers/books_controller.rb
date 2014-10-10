class BooksController < ApplicationController
  def index
    @books = Book.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
end
