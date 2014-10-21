class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer

  def increment_usage!(usage_increment)
    update_attribute :usage, usage + usage_increment
  end
end
