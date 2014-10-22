class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer

  def to_s
    '#%d %s <%s>' % [id, created_at, user.email]
  end

  def increment_usage!(usage_increment)
    update_attribute :usage, usage + usage_increment
  end

  def quota_exceeded?
    usage >= quota
  end
end
