module ActiveRecord
  module LookML
    class ArrayField
      def initialize(name:, values:)
        @name = name
        @values = values
      end

      def to_lookml(indent_level: 0)
        indent = '  ' * indent_level
        lookml = "#{indent}#{@name}: [\n"
        lookml << @values.map do |value|
          "#{indent}  #{value}"
        end.join(",\n")
        lookml << "\n"
        lookml << "#{indent}]\n"
        lookml
      end
    end
  end
end
