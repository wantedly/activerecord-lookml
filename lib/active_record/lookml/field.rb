module ActiveRecord
  module LookML
    class Field
      def initialize(name:, value:)
        @name = name
        @value = value
      end

      def to_lookml(indent_level: 0)
        indent = '  ' * indent_level
        "#{indent}#{@name}: #{@value}\n"
      end
    end
  end
end
