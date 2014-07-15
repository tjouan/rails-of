class WorkForm < FormBase
  class GeoScoreForm < WorkForm
    def_delegators :@object, :parameters
  end


  class OpticibleForm < WorkForm
    def setup
      return unless source

      source.headers.each do |h|
        define_parameters_ignore h.position, false
      end
    end

    def parameters=(value)
      ignored_parameters = value[:ignore].reject(&:empty?)
      object.parameters = [
        value[:id],
        value[:target],
        ignored_parameters.join(',')
      ]
      ignored_parameters.each do |e|
        define_parameters_ignore e, true, force: true
      end
    end

    def need_target?
      return true
    end

    def parameters_id
      object.parameters ? object.parameters[0] : nil
    end

    def parameters_target
      object.parameters ? object.parameters[1] : nil
    end

    def define_parameters_ignore(position, value, force: false)
      return if respond_to?("parameters_ignore_#{position}") unless force

      define_singleton_method("parameters_ignore_#{position}") { value }
    end
  end


  OPERATION_FORMS = {
    geoscore:   GeoScoreForm,
    opticible:  OpticibleForm
  }.freeze

  ATTRIBUTES_DELEGATED = %i[
    id
    operation
    source
    source_id
    target_source
    target_source_id
  ].freeze

  def_delegators :@object, *ATTRIBUTES_DELEGATED

  class << self
    def build(params)
      operation = Operation.find(params[:operation_id])
      OPERATION_FORMS[operation.ref.to_sym].new(params)
    end

    def resource
      Work
    end
  end

  def need_target?
    return false
  end
end
