Apipie.configure do |config|
  config.app_name                = "Plans"
  config.copyright               = "&copy; 2015 Oscar | Andela"
  config.api_base_url            = ""
  config.doc_base_url            = "docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*/*.rb"
  config.show_all_examples = true
  config.validate = false
  config.markup = Apipie::Markup::Markdown.new
  config.use_cache = true #Rails.env.production?
  config.app_info                = "Plans provides an API service that allows user create and manage bucketlists (and bucketlist items).
  Users of the service can have many bucketlists and a bucketlist can have many items. Items can be marked as done or pending. A possible flow of the use of the API service is outlined below."
end
