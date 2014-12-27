class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  has_many :identities, :dependent => :destroy
  has_one :cart, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  has_many :cards, :dependent => :destroy
  after_create :create_cart_for_user, :create_stripe_customer_for_user
  
  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email || auth.provider == "google_oauth2" || auth.provider == "linkedin")
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email
      if user.nil?
        user = User.new(name: auth.info.name,
        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
        password: Devise.friendly_token[0,20],
        )
        user.save!
      end
    end
    if auth.provider == "facebook"
      user.fbOAuthToken =  auth.credentials.token
      user.fbAppScopedLink = auth.extra.raw_info.link
      user.save     
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end
  
  def create_cart_for_user
    self.cart = Cart.new
  end
  
  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def do_payment
    status = "success"
    begin
    charge = Stripe::Charge.create(
        :amount => self.cart.amount, # amount in cents, again
        :currency => "usd",
        :customer => self.stripe_customer_id,
        :description => "User paying for books"
      )
      rescue Stripe::CardError => e
        puts e.message
        status = "failure"
      end
    save_card_by_charge(charge.card)
    save_payment(status, charge.card.id)
    status
  end
  
  def save_payment( status, card_id )
    payment = Payment.new
    payment.status = status
    payment.user = self
    payment.card_id = card_id
    payment.save
  end
  
  def pay_by_card(card_id)
    status = "success"
    puts card_id
    puts self.stripe_customer_id
    begin
    charge = Stripe::Charge.create(
        :amount => self.cart.amount, # amount in cents, again
        :currency => "usd",
        :customer => self.stripe_customer_id,
        :card => card_id,
        :description => "User paying for books by saved card"
      )
      rescue Stripe::CardError => e
        puts e.message
        status = "failure"
      end
    save_payment(status, charge.card.id)
    if(status == "success")
      cart = self.cart
      cart.cart_items = []
      cart.amount = 0
      cart.save
    end
    status
  end
  
  def save_card_by_charge( parsed_card )
    card_fingerprint = parsed_card.fingerprint
    unless self.cards.present?
      add_card_to_customer( parsed_card.id,  card_fingerprint)
    else
      found = false
      self.cards.each do |c|
        if c.fingerprint == card_fingerprint
          found = true
        end
        if (!found)
          add_card_to_customer( parsed_card.id, card_fingerprint )
        end
      end 
    end
    self.save 
  end
  
  def add_card_to_customer( token, id )
    cu = Stripe::Customer.retrieve(self.stripe_customer_id)
    cu.cards.create(:card => token) # obtained with Stripe.js
    cu.save
    retrieved_card = cu.cards.retrieve(id)
    card = Card.new
    card.fingerprint = retrieved_card.fingerprint
    self.cards = [] unless self.cards.present?
    self.cards.push(card)
    self.save
  end
  
  def create_stripe_customer_for_user
    response = Stripe::Customer.create(
      :description => "Customer for test@example.com",
      :email => self.email,
      :metadata => {
        :user_id => self.id 
      }
    )
    self.stripe_customer_id = response.id
    self.save
  end
  
  def get_user_payments( after_id = nil )
    response = Stripe::Charge.all(
      :customer => self.stripe_customer_id,
      :starting_after => after_id
      )
    response
  end
  
  def get_user_cards
    cards = Stripe::Customer.retrieve(self.stripe_customer_id).cards.all(:limit => 10)
    puts cards
    if cards.count > 0
      cards.data
    end
  end
  
  def subscribe( id )
    status = "success"
    customer = Stripe::Customer.retrieve(self.stripe_customer_id)
    if self.subscription_id.blank?
      begin
      customer.subscriptions.create(:plan => id)
      rescue Stripe::CardError => e
        puts e.message
        status = "failure"
      end      
    else
      status = "failure"
    end
    if status == "success"
      self.subscription_id = id
      self.save
    end
    status
  end
  
  def get_customer_subscriptions
    Stripe::Customer.retrieve(self.stripe_customer_id).subscriptions.all().data
  end
  
  # def apply_coupon( coupon_id )
    # coupon = Stripe::Coupon.retrieve(coupon_id)
    # if coupon.valid == true
      # #create invoice from coupon by discount object
      # Stripe::Invoice.create(
        # :customer => self.stripe_customer_id,
        # :discount => {
          # :coupon => coupon,
          # :customer => self.stripe_customer_id,
        # }
      # )  
    # end
  # end
end
