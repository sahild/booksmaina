class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      user_by_email = User.find_by_email(user_params[:email])
      if(user_by_email.nil?)
        if @user.update(user_params)
          sign_in(@user, :bypass => true)
          redirect_to root_url, notice: 'Your profile was successfully updated.'
        else
          @show_errors = true
        end
      else
        provider = @user.email[@user.email.rindex('-')+1..@user.email.rindex('.')-1]
        puts provider
        user_identity = @user.identities.find_by_provider(provider)
        user_identity.user = user_by_email
        user_identity.save
        User.destroy(@user.id)
        sign_in(user_by_email)
        redirect_to root_url, notice: 'Welcome back '+ user_by_email.name
      end
    end
  end
# DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  def card_token
    token = params[:stripeToken]
    card_id = params[:stripeCardId]
    current_user.add_card_to_customer(token, card_id)
    failed = current_user.pay_by_card(card_id)
    if failed == "failure"
      redirect_to :card_details
    else
      redirect_to :root
    end
  end
  
  def choose_card
    @cards = current_user.get_user_cards
    unless @cards.present?
      redirect_to :card_details
    end
  end
  
  def card_details
    @cart = current_user.cart
  end
  
  def do_payment
    card_id = params[:card_id]
    failed = current_user.pay_by_card(card_id)
    if failed == "failure"
      redirect_to :choose_card
    else
      redirect_to :root
    end
  end
  
  def subscriptions
    @subscriptions = current_user.get_customer_subscriptions
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :avatar ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end