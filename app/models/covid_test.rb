class CovidTest
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :customer
  field :test_date, type: Date
  field :test_time, type: Time
  field :test_day, type: String
  field :result_type, type: String
end
