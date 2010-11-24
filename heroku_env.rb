heroku_config = File.expand_path('../heroku.yml', __FILE__)
if File.exists?(heroku_config)
  config = YAML.load_file(heroku_config)
  config.fetch(Rails.env, {}).each do |key, value|
    ENV[key.upcase] = value.to_s
  end
end
