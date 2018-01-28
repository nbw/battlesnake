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

  def self.read
    YAML.load(ERB.new(File.read(SETTINGS_PATH)).result)
  end

end
