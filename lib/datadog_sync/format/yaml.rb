class DatadogSync
  private

  def load_yaml_file(path)
    yaml_to_hash(YAML.load_file(path))
  end

  def yaml_to_hash(data)
    dashboard = {}
    dashboard["graphs"] = []

    ["id", "title", "description", "template_variables"].each do |compat_key|
      dashboard[compat_key] = data[compat_key]
    end

    data["graphs"].each do |graph|
      dashboard["graphs"] << format_graph(graph, data["global_filters"])
    end

    return dashboard
  end

  def format_graph(graph, global_filters)
    final_graph = {}

    final_graph["title"] = graph["title"]
    viz = graph["viz"] || "timeseries"

    requests = []
    graph["requests"].each do |request|
      requests << format_request(request, global_filters, graph["type"])
    end

    definition = {
      viz: viz,
      requests: requests
    }

    final_graph["definition"] = definition

    return final_graph
  end

  def format_request(request, global_filters, default_type=nil)
    query = request["q"]
    case query
    when Array
      query.map! { |q| add_global_filters(q, global_filters) }
      final_query = query.join(", ")
      suggested_type = "area"
    when String
      final_query = add_global_filters(query, global_filters)
      suggested_type = "line"
    end
    type = request["type"] || default_type || suggested_type
    final_request = {
      q: final_query,
      type: type
    }
    final_request["style"] = request["style"] if request["style"]
    return final_request
  end

  def add_global_filters(query, global_filters)
    filters = global_filters.join(',')
    regexp_with_filters = Regexp.new('(.+?)\{(.+?)\}')
    if query =~ regexp_with_filters
      query.gsub(regexp_with_filters, "\\1{\\2,#{filters}}")
    else
      query += "{#{filters}}"
    end
  end
end
