class Settingslogic < Hash
  def method_missing(name, *args, &block)
    super if name === :to_ary # delegate to_ary to Hash. see https://github.com/binarylogic/settingslogic/pull/36
    key = name.to_s
    return missing_key("Missing setting '#{key}' in #{@section}") unless has_key? key
    value = fetch(key)
    create_accessor_for(key)
    value.is_a?(Hash) ? self.class.new(value, "'#{key}' section in #{@section}") : value
  end
end
