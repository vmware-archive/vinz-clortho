require 'test_helper'

module Vinz
  module Clortho
    class FileWrapperTest < Minitest::Test

      def setup
        @file_path = 'id_rsa.pub'
        new_file = File.open(@file_path, 'w')
        new_file.write('contents')
        new_file.chmod(0444)
        new_file.close
      end

      def teardown
        File.delete(@file_path)
      end

      def test_initialize
        wrapper = FileWrapper.new(@file_path, 'r')
        file = wrapper.instance_variable_get(:@file)
        assert file.instance_of?(File)
        assert_equal @file_path, file.path
        assert File.readable?(file)
        refute File.writable?(file)
        refute File.executable?(file)
      end

      def test_self_open
        FileWrapper.expects(:new).with(@file_path, 'r').returns('FileWrapper instance')
        assert_equal 'FileWrapper instance', FileWrapper.open(@file_path, 'r')
      end

      def test_read
        wrapper = FileWrapper.new(@file_path, 'r')
        assert_equal 'contents', wrapper.read
      end

    end
  end
end
