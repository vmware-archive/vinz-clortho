module Vinz
  module Clortho
    class FileWrapper

      def initialize(path, mode)
        @file = File.new(path, mode)
      end

      def self.open(path, mode)
        new(path, mode)
      end

      def read
        @file.read
      end

    end
  end
end