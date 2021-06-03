module ActiveRecord
  module LookML
    class Block
      def initialize(type:, name:)
        @type = type
        @name = name
        @fields = []
        yield(self) if block_given?
      end

      def <<(new_field)
        @fields << new_field
      end

      def to_lookml(indent_level: 0)
        indent = '  ' * indent_level
        lookml = "#{indent}#{@type}:"
        lookml << " #{@name}" if @name
        lookml << " {\n"
        @fields.each_with_index do |field, index|
          lookml << "\n" if index > 0 && field.is_a?(Block)
          lookml << field.to_lookml(indent_level: indent_level + 1)
        end
        lookml << "#{indent}}\n"
        lookml
      end
    end
  end
end
