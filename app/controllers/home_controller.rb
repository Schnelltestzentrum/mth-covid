class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    redirect_to new_customer_url
  end
end
