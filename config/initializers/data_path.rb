Rails.application.config.data_files_path = Rails.env.test? ?
  File.join('data', Rails.env, 'data_files') :
  File.join('data', 'data_files')
