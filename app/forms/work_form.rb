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


  OPERATION_FORMS = {
    firstnames: FirstnamesForm,
    geoscore:   GeoScoreForm,
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
