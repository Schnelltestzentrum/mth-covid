class CustomersController < ApplicationController
  before_action :authenticate_user!, except: [:signature, :add]
  layout 'outside', only: [:add]
  
  def index
    @start_date = params[:start_date] || Date.today.beginning_of_month
    @end_date = params[:end_date] || Date.today
    @page = params[:page] || 0

    @customers = current_user.customers.where(form_date: @start_date..@end_date)
    respond_to do |format|
      format.html { @customers = @customers.page(@page) }
      format.js { @customers = @customers.page(@page) }
      format.xls {
        @spreadsheet = CustomerSpreadsheet.new(@customers, signature_customers_url)
        file = @spreadsheet.genarate
        send_file("#{Rails.root}/#{file}")
      }
    end
  end

  def new
    @customer = Customer.new
  end

  def add
    @user = User.find(params[:id])
    new
    render :new
  end

  def create
    params[:customer][:signature] = convert_data_uri_to_upload(params[:customer][:signature]) if params[:customer][:signature].present?
    params[:customer][:user_signature] = convert_data_uri_to_upload(params[:customer][:user_signature]) if params[:customer][:user_signature].present?
    @customer = Customer.new(customer_params)
    @customer.user_id = current_user.id
    respond_to do |format|
      if @customer.save
        format.html { redirect_to new_customer_url, flash: {success: 'Record Created Successfully'}}
      else
        flash[:error] = @customer.errors.messages.collect{|k, v| "#{k.to_s.humanize} #{v[0]}"}
        format.html { render :new }
      end
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def signature
    show
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :first_name, :dob, :address, :post, :phone, :email,
     :customer_confirmation, :test_date, :test_time, :test_day, :result_type, :test_id, :form_date,
    :test_by, :total_person, :signature, :user_signature, :test_result, :test_type, :dobs)
  end

  def convert_data_uri_to_upload(obj_hash)
    if obj_hash.try(:match, %r{^data:(.*?);(.*?),(.*)$})
      image_data = split_base64(obj_hash)
      image_data_string = image_data[:data]
      image_data_binary = Base64.decode64(image_data_string)

      temp_img_file = Tempfile.new("data_uri-upload")
      temp_img_file.binmode
      temp_img_file << image_data_binary
      temp_img_file.rewind

      img_params = { :filename => "data-uri-img.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file }
      uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

      obj_hash = uploaded_file
    end

    return obj_hash
  end

  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

end

  
 