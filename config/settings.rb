require 'yaml'
require 'erb'

module Settings
  SETTINGS_PATH = "#{File.dirname(__FILE__)}/settings.yml"
  
  def self.get *args
    args.inject(self.read){|res, arg| res[arg]} 
  rescue 
    nil
  end

  private

  def self.path
    unless ENV["RACK_ENV"] == "production"
      "#{File.dirname(__FILE__)}/settings_dev.yml"
    else
      "#{File.dirname(__FILE__)}/settings.yml"
    end
  end

  def self.read
    YAML.load(ERB.new(File.read(self.path)).result)
  end

end
