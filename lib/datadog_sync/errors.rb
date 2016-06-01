class DatadogSync
  # Raised when something doesn't exist
  DoesNotExist = Class.new(RuntimeError)

  # Raised when something already exists
  AlreadyExists = Class.new(RuntimeError)
end
