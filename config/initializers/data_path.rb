Rails.application.config.sources_path = Rails.env.test? ?
  File.join('data', Rails.env, 'sources') :
  File.join('data', 'sources')
