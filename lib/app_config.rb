class AppConfig
  include Singleton

  def config
    @config ||= YAML.load_file(File.join(File.expand_path('..', File.dirname(__FILE__)), 'config.yml'))
  end
end