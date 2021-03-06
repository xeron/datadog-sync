class DatadogSync
  # Update dashboards in Datadog from the local filesystem (import to DD).
  #
  # ==== Attributes
  # * +dashboards_path+ - local path where to load json files from (String)
  # * +title_pattern+ - pattern to filter dashboards by name using regex, empty by default (String)
  # ==== Returns
  # * IDs of updated dashboards (Array)
  def update_dashboards(dashboards_path, title_pattern="", format=:json)
    regex = Regexp.new(title_pattern)
    base_path = File.expand_path(dashboards_path)

    unless File.directory?(base_path)
      logger.error "Provided gashboards path does not exist."
      raise DoesNotExist
    end

    all_dash_files = Dir.glob(File.join(base_path, "*"))

    logger.info "Found #{all_dash_files.count} local dashboards"

    filtered_dashes = []
    filtered_dashes_ids = []

    all_dash_files.each do |file|
      data = case format
      when :yaml
        load_yaml_file(file)
      else
        load_json_file(file)
      end
      if data["title"] =~ regex
        filtered_dashes << data
        filtered_dashes_ids << data["id"]
      end
    end

    logger.info "Updating #{filtered_dashes.count} dashboards with pattern /#{title_pattern}/ from '#{base_path}'"

    import_dashboards(filtered_dashes)

    return filtered_dashes_ids
  end

  private

  def import_dashboards(dashes)
    dashes.each do |dash|
      import_dashboard(dash)
    end
  end

  def import_dashboard(dash)
    dd_client.update_dashboard(
      dash["id"], dash["title"], dash["description"],
      dash["graphs"], dash["template_variables"]
    )
  end
end
