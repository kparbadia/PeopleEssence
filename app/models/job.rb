class Job < ActiveRecord::Base
  has_many :job_details
end
