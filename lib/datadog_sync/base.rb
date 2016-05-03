class DatadogSync
  attr_reader :dd_client, :logger

  def initialize(api_key, app_key, options={})
    default_options = {
      log_level: :info,
      log_target: STDOUT
    }
    final_options = default_options.merge(options)

    @dd_client = Dogapi::Client.new(api_key, app_key)

    set_logger(final_options)
  end

  private

  def sanitize_filename(filename)
    filename.gsub(/[\?\*\/\\]/, "_")
  end

  def set_logger(config)
    @logger = Logger.new(config[:log_target])
    @logger.level = config[:log_level]
    @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
  end
end
