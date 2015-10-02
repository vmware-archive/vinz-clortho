require 'test_helper'

module Vinz::Clortho
  class PushAuthenticatedTest < Minitest::Test
    def test_calls_ssh_setup_login_all
      SSHSetup.any_instance.expects(:login_all).with(5)
      kernel = mock("kernel")
      Cli::PushAuthenticated.any_instance.expects(:kernel).returns(kernel)
      kernel.expects(:system).with('git push foo bar')
      subject = Cli::PushAuthenticated.new
      subject.perform('foo', 'bar')
    end
  end
end
