class Plan
  def self.get_all_plans( after_id = nil )
    Stripe::Plan.all(
      :starting_after => after_id
      )
  end
  
  def self.get_details( id )
    Stripe::Plan.retrieve(id)
  end
end