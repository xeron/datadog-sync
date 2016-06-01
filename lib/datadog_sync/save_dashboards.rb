class DatadogSync
  # Save dashboards from Datadog to the filesystem (export from DD).
  #
  # ==== Attributes
  # * +dashboards_path+ - local path where to save json files with dashboard data (String)
  # * +title_pattern+ - pattern to filter dashboards by name using regex, empty by default (String)
  # ==== Returns
  # * IDs of saved dashboards (Array)
  def save_dashboards(dashboards_path, title_pattern="")
    regex = Regexp.new(title_pattern)
    base_path = File.expand_path(dashboards_path)

    if File.file?(base_path)
      logger.error "Provided gashboards path already exists and it's not a directory."
      raise AlreadyExists
    elsif !File.directory?(base_path)
      logger.info "Creating directory for dashboards: '#{base_path}'"
      FileUtils.mkdir_p(base_path)
    end

    all_dashes = dd_client.get_dashboards[1]["dashes"]

    logger.info "Found #{all_dashes.count} dashboards"

    filtered_dashes = all_dashes.select { |dash| dash["title"] =~ regex }
    filtered_dashes_ids = filtered_dashes.collect { |dash| dash["id"].to_i }

    logger.info "Saving #{filtered_dashes.count} dashboards with pattern /#{title_pattern}/ into '#{base_path}'"

    filtered_dashes_ids.each do |dash_id|
      dash_data = dd_client.get_dashboard(dash_id)[1]["dash"]
      filename = sanitize_filename(dash_data["title"])
      filepath = File.join(base_path, "#{filename}.json")
      File.open(filepath, "wb") do |f|
        f.puts JSON.pretty_generate(dash_data)
      end
    end

    return filtered_dashes_ids
  end
end
