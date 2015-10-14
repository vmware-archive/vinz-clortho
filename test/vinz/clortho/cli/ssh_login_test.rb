require 'test_helper'

module Vinz
  module Clortho
    class SSHLoginTest < Minitest::Test
      attr_reader :subject, :ssh_setup, :kernel
      def setup
        @kernel = mock('kernel')
        @subject = Cli::SSHLogin.new
        @ssh_setup = SSHSetup.any_instance
      end

      def test_default_action
        subject.expects(:kernel).at_least_once.returns(kernel)
        ssh_setup.expects(:login).with('nc')
        kernel.expects(:puts).with { |v| v =~ /^Key will expire at/ }
        subject.perform('nc')
      end

      def test_failure_doesnt_print_key_expiry
        subject.stubs(:kernel).returns(kernel)
        ssh_setup.expects(:login).with('nc').raises
        kernel.expects(:puts).with { |v| v =~ /^Key will expire at/ }.never
        begin; subject.perform('nc'); rescue; end
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
        kernel.expects(:puts)

        uploader.expects(:upload).with("key_title")
        subject.add_to_github('hp')
      end
    end
  end
end
0