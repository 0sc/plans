Apipie.configure do |config|
  config.app_name                = "Bucketlist"
  config.copyright               = "&copy; 2015 Oscar | Andela"
  config.app_info                = ""
  config.api_base_url            = ""
  config.doc_base_url            = "documentation"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.show_all_examples = true
  config.validate = false
end
