class PaymentsController < ApplicationController
  def index
    payments_obj = current_user.get_user_payments(params[:after])
    @payments = payments_obj.data
  end
end