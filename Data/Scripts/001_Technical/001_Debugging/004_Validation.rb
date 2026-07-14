#===============================================================================
# The Kernel module is extended to include the validate method.
#===============================================================================
module Kernel
  private

  # Used to check whether method arguments are of a given class or respond to a method.
  # @param value_pairs [Hash{Object => Class, Array<Class>, Symbol}] value pairs to validate
  # @example Validate a class or method
  #   validate foo => Integer, baz => :to_s # raises an error if foo is not an Integer or if baz doesn't implement #to_s
  # @example Validate a class from an array
  #   validate foo => [Sprite, Bitmap, Viewport] # raises an error if foo isn't a Sprite, Bitmap or Viewport
  # @raise [ArgumentError] if validation fails
  def validate(value_pairs)
    unless value_pairs.is_a?(Hash)
      raise ArgumentError, "非哈希参数#{value_pairs.inspect}传递进入检验。"
    end
    errors = value_pairs.map do |value, condition|
      if condition.is_a?(Array)
        unless condition.any? { |klass| value.is_a?(klass) }
          next "预期#{value.inspect}为#{condition.inspect}之一，但得到了#{value.class.name}。"
        end
      elsif condition.is_a?(Symbol)
        next "预期#{value.inspect}响应#{condition}方法。" unless value.respond_to?(condition)
      elsif !value.is_a?(condition)
        next "预期#{value.inspect}为#{condition.name}类型，但得到了#{value.class.name}。"
      end
    end
    errors.compact!
    return if errors.empty?
    raise ArgumentError, "传递给方法的参数无效。\r\n" + errors.join("\r\n")
  end
end
