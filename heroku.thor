require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string/inflections'

module Deploy
  extend self

  module Support
    private

    def heroku(command)
      command "heroku #{command} --app #{heroku_app}"
    end

    def command(command)
      puts command
      system command
    end

    def environment
      self.class.to_s.demodulize.underscore
    end

    def heroku_env
      @heroku_env ||= Deploy.heroku_config[environment]
    end

    def heroku_app
      @heroku_app ||= Deploy.heroku_config[:apps][environment]
    end
  end

  def self.commands_for_environment(app_env)
    module_eval do
      klass = Class.new(Thor) do
        include Support

        desc "rack_env", "Set the RACK_ENV config variable"
        def rack_env
          heroku("config:add RACK_ENV=#{environment}")
        end

        desc "config", "Set config variables"
        def config
          env_values = [].tap do |e|
            heroku_env.each do |key, value|
              e << "#{key.upcase}='#{value}'"
            end
          end
          heroku("config:add #{env_values.join(' ')}")
        end
      end

      const_set(app_env.classify, klass)
    end
  end

  def heroku_config
    @heroku_config ||= YAML.load_file(File.expand_path('../../../config/heroku.yml', __FILE__)).with_indifferent_access
  end

  heroku_config[:apps].each_key do |app_env|
    commands_for_environment(app_env)
  end
end
