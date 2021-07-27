
class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  validates_presence_of :name, :first_name, :dob, :test_date, :test_time, :form_date

  belongs_to :user
  mount_uploader :signature, SignatureUploader
  mount_uploader :user_signature, SignatureUploader

  field :name, type: String
  field :first_name, type: String
  field :dob, type: Date
  field :address, type: String
  field :post, type: String
  field :phone, type: String
  field :email, type: String
  field :customer_confirmation, type: Boolean

  field :test_date, type: Date
  field :test_time, type: Time
  field :test_day, type: String
  field :result_type, type: String
  field :test_id, type: String
  field :form_date, type: Date
  field :test_by, type: String
  field :total_person, type: Integer
end
