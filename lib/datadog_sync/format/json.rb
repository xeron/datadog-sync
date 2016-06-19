class DatadogSync
  private

  def load_json_file(path)
    JSON.parse(File.read(path))
  end
end
