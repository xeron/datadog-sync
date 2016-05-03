class DatadogSync
  def save_dashboards(title_pattern, dashboards_path)
    regex = Regexp.new(title_pattern)
    base_path = File.expand_path(dashboards_path)

    if File.file?(base_path)
      raise AlreadyExists, "Provided gashboards path already exists and it's not a directory."
    elsif !File.directory?(base_path)
      puts "Creating directory for dashboards: '#{base_path}'"
      FileUtils.mkdir_p(base_path)
    end

    all_dashes = dd_client.get_dashboards[1]["dashes"]

    puts "Found #{all_dashes.count} dashboards"

    filtered_dashes = all_dashes.select { |dash| dash["title"] =~ regex }
    filtered_dashes_ids = filtered_dashes.collect { |dash| dash["id"] }

    puts "Saving #{filtered_dashes.count} dashboards with pattern /#{title_pattern}/ into '#{base_path}'"

    filtered_dashes_ids.each do |dash_id|
      dash_data = dd_client.get_dashboard(dash_id)[1]["dash"]
      filename = sanitize_filename(dash_data["title"])
      filepath = File.join(base_path, "#{filename}.json")
      File.open(filepath, "wb") do |f|
        f.puts JSON.pretty_generate(dash_data)
      end
    end
  end
end
