class FormBase
  extend Forwardable
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class << self
    def build(*args)
      new(*args)
    end

    def delegate_attributes(attrs)
      def_delegators :@object, *attrs
    end

    def resource(res)
      self.define_singleton_method(:attached_resource) { res }
    end
  end

  attr_reader :object

  def initialize(attributes = {}, object = self.class.attached_resource.new)
    define_model_name
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
    object.persisted?
  end

  def before_save
  end

  def save
    before_save
    if valid? && object.valid?
      object.save
    else
      object.valid?
      merge_errors and false
    end
  end


  private

  def define_model_name
    self.class.define_singleton_method(:model_name) do
      ActiveModel::Name.new(self.attached_resource)
    end
  end

  def merge_errors
    object.errors.each { |k, v| errors[k] = v }
  end
end
