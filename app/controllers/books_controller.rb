class BooksController < ApplicationController
  def index
    @books = Book.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @book = Book.find(params[:id])
  end
  
  def add_to_cart
    @book = Book.find(params[:id])
    @cart = current_user.cart
    unless @cart.present?
      @cart = current_user.cart.create()
    end
    cart_item = CartItem.create()
    cart_item.book = @book
    cart_item.cart = @cart
    cart_item.count = 1
    unless @cart.cart_items.present?
      @cart.cart_items = []
    end
    if @cart.amount.nil?
      @cart.amount = 0.0
    end
    @cart.cart_items.push(cart_item)
    @cart.amount += @book.price
    @cart.save
    render "carts/show"
  end
end
