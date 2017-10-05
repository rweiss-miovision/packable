require 'stringio'

module Packable
  module Extensions #:nodoc:
    module String #:nodoc:

      def self.included(base)
        base.class_eval do
          include Packable
          extend ClassMethods
          prepend UnpackableMethods
          packers.set :merge_all, :fill => " "
        end
      end

      module UnpackableMethods
        def unpack_with_long_form(*arg)
          return super(*arg) if arg.first.is_a? String
          StringIO.new(self).packed.read(*arg)
        rescue EOFError
          nil
        end
      end

      def write_packed(io, options)
        return io.write(self) unless options[:bytes]
        io.write(self[0...options[:bytes]].ljust(options[:bytes], options[:fill] || "\000"))
      end

      module ClassMethods #:nodoc:
        def unpack_string(s, options)
          s
        end
      end

    end
  end
end
