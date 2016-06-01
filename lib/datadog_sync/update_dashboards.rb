class DatadogSync
  def update_dashboards(dashboards_path, title_pattern="")
    regex = Regexp.new(title_pattern)
    base_path = File.expand_path(dashboards_path)

    unless File.directory?(base_path)
      logger.error "Provided gashboards path does not exist."
      raise DoesNotExist
    end

    all_dash_files = Dir.glob(File.join(base_path, "*"))

    logger.info "Found #{all_dash_files.count} local dashboards"

    filtered_dashes = []
    all_dash_files.each do |file|
      data = JSON.parse(File.read(file))
      filtered_dashes << data if data["title"] =~ regex
    end
    # filtered_dashes_ids = filtered_dashes.collect { |dash| dash["id"] }

    logger.info "Updating #{filtered_dashes.count} dashboards with pattern /#{title_pattern}/ from '#{base_path}'"

    filtered_dashes.each do |dash|
      dd_client.update_dashboard(dash["id"], dash["title"], dash["description"], dash["graphs"], dash["template_variables"])
    end
  end
end
