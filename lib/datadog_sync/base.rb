class DatadogSync
  attr_reader :dd_client

  def initialize(api_key, app_key)
    @dd_client = Dogapi::Client.new(api_key, app_key)
  end

  def sanitize_filename(filename)
    filename.gsub(/[\?\*\/\\]/, "_")
  end
end
