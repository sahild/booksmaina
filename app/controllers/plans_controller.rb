class PlansController < ApplicationController
  def index
    @plans = Plan.get_all_plans(params[:after]).data
  end
  
  def subscribe
    status = current_user.subscribe(params[:id])
    if status == "failure"
      redirect_to :index
    else
      redirect_to :root
    end
  end
  
  def show
    @plan= Plan.get_details( params[:id] )
  end
end