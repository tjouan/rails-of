data_path_root = 'data'

Rails.application.config
  .data_files_path = File.join(data_path_root, Rails.env, 'data_files')
