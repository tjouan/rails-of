class WorkForm < FormBase
  class FirstnamesForm < WorkForm
    delegate_attributes :parameters
  end

  class GeoScoreForm < WorkForm
    delegate_attributes :parameters
  end

  class INSEEForm < WorkForm
    delegate_attributes :parameters
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
        value[:target],
        ignored_parameters.join(','),
        value[:cost],
        value[:margin]
      ]
      ignored_parameters.each do |e|
        define_parameters_ignore e, true, force: true
      end
    end

    def need_target?
      return true
    end

    def parameters_target
      object.parameters ? object.parameters[1] : nil
    end

    def parameters_cost
      object.parameters ? object.parameters[2] : nil
    end

    def parameters_margin
      object.parameters ? object.parameters[3] : nil
    end


    private

    def define_parameters_ignore(position, value, force: false)
      return if respond_to?("parameters_ignore_#{position}") unless force

      define_singleton_method("parameters_ignore_#{position}") { value }
    end
  end


  OPERATION_FORMS = {
    firstnames: FirstnamesForm,
    geoscore:   GeoScoreForm,
    opticible:  OpticibleForm,
    insee:      INSEEForm
  }.freeze

  resource Work

  validate :user_quota

  delegate_attributes %i[
    id
    operation
    source
    source_id
    target_source
    target_source_id
    user
  ]

  class << self
    def build(*args)
      operation = Operation.find(args.first[:operation_id])
      OPERATION_FORMS[operation.ref.to_sym].new(*args)
    end
  end

  def need_target?
    return false
  end

  def user_quota
    return unless object.usage

    if object.usage > user.usage_left
      usage_needed = object.usage - user.usage_left
      errors.add :user_quota,
        'Quota actuel insuffisant (manque %s)' % usage_needed
    end
  end
end
