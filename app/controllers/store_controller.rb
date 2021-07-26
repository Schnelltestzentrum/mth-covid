class StoreController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(usr_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to new_customer_url, flash: {success: 'Store Created Successfully'}}
      else
        flash[:error] = @user.errors.messages.collect{|k, v| "#{k.to_s.humanize} #{v[0]}"}
        format.html { render :new }
      end
    end 
  end

  private
  def usr_params
    params.require(:user).permit(:email, :password, :username, :shop_name, :address)
  end
end
