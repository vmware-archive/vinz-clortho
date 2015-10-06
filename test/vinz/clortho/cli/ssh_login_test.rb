require 'test_helper'

module Vinz
  module Clortho
    class SSHLoginTest < Minitest::Test
      attr_reader :subject, :setup, :kernel
      def setup
        @subject = Cli::SSHLogin.new
        @kernel = mock('kernel')
        @setup = SSHSetup.any_instance
      end

      def test_default_action
        setup.expects(:login).with('nc')
        subject.perform('nc')
      end

      def test_add_to_github
        subject.expects(:kernel).at_least_once.returns(kernel)

        uploader = mock()
        Vinz::Clortho::GithubKeyUploader.expects(:new).with("hp", "hpotter", "password").returns(uploader)

        kernel.expects(:print).with("Enter title for key: ")
        kernel.expects(:gets).returns("key_title")
        kernel.expects(:print).with("Enter your username: ")
        kernel.expects(:gets).returns("hpotter")
        kernel.expects(:print).with("Enter your password: ")
        STDIN.expects(:noecho).returns("password")

        uploader.expects(:upload).with("key_title")
        subject.add_to_github('hp')
      end
    end
  end
end
0