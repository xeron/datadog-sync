class DatadogSync
  def save_dashboards(title_pattern, dashboards_path)
    regex = Regexp.new(title_pattern)

    all_dashes = dd_client.get_dashboards[1]["dashes"]
    filtered_dashes = all_dashes.select { |dash| dash["title"] =~ regex }
    filtered_dashes_ids = filtered_dashes.collect { |dash| dash["id"] }

    filtered_dashes_ids.each do |dash_id|
      dash_data = dd_client.get_dashboard(dash_id)[1]["dash"]
      filename = sanitize_filename(dash_data["title"])
      filepath = File.join(File.expand_path(dashboards_path), "#{filename}.json")
      File.open(filepath, "wb") do |f|
        f.puts JSON.pretty_generate(dash_data)
      end
    end
  end
end
