class FormBase
  extend Forwardable
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class << self
    def build(object)
      new(object)
    end

    def model_name
      ActiveModel::Name.new(resource)
    end
  end

  attr_reader :object

  def initialize(attributes = {}, object = self.class.resource.new)
    @object = object

    attributes.each do |k, v|
      m = "#{k}="

      if respond_to? m
        send m, v
      else
        object.send "#{k}=", v
      end
    end

    setup
  end

  def setup
  end

  def persisted?
    false
  end

  def before_save
  end

  def save
    before_save
    valid? and object.save
  end
end
