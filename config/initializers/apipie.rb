Apipie.configure do |config|
  config.app_name                = "Plans"
  config.copyright               = "&copy; 2015 Oscar | Andela"
  config.app_info                = ""
  config.api_base_url            = ""
  config.doc_base_url            = "docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/v1/*.rb"
  config.show_all_examples = true
  config.validate = false
  config.markup = Apipie::Markup::Markdown.new
  config.use_cache = Rails.env.production?
end
