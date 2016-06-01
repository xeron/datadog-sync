# Tool to import/export Datadog dashboards.
# * Backup in case if someone accidentally deletes dashboard and ability to recreate it with single command
# * Ability to keep dashboards in git repo, make modifications using text editor, suggest Pull Requests
# * YAML format providing simpler way to describe dashboards without repeating a lot of things in chatty JSON. Example: https://github.com/xeron/datadog-sync/blob/master/examples/dashboard_example.yml
# * Automation purposes (for example creating new dashboard or adding graphs when you deploy new version of application)
class DatadogSync
  attr_reader :dd_client, :logger

  # Create DatadogSync instance.
  #
  # ==== Attributes
  # * +api_key+ - Datadog API key (String)
  # * +app_key+ - Datadog APP key (String)
  # * +options+ - Options (Hash)
  #   * +log_level+ - :debug < :info < :warn < :error < :fatal < :unknown
  #   * +log_target+ - log file path, +STDOUT+ by default
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
