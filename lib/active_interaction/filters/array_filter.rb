module ActiveInteraction
  # @private
  class ArrayFilter < Filter
    def self.prepare(key, value, options = {}, &block)
      case value
        when Array
          convert_values(value, &block)
        else
          super
      end
    end

    def self.convert_values(values, &block)
      return values.dup unless block_given?

      filter_method = get_filter_method(FilterMethods.evaluate(&block))

      values.map do |value|
        Filter.factory(filter_method.method_name).prepare(filter_method.attribute, value, filter_method.options, &filter_method.block)
      end
    end
    private_class_method :convert_values

    def self.get_filter_method(filter_methods)
      if filter_methods.count > 1
        raise ArgumentError, 'Array filter blocks can only contain one filter.'
      else
        filter_method = filter_methods.first
      end
    end
    private_class_method :get_filter_method
  end
end