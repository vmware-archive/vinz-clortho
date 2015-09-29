require 'yaml'
gem 'mocha'
require 'minitest/autorun'
require 'mocha/mini_test'
require_relative '../../lib/clortho/ssh_setup'


module Clortho
  class SSHSetupTest < Minitest::Test

    def setup
      initial_committers = {"authors" => {"hp" => "Harry Potter", "hg" => "Hermione Granger"},
                            "emails" => {"hp" => "hpotter@pivotal.io", "hg" => "hgranger@pivotal.io"},
                            "sshkey_paths" =>
                                {"hp" => "/Volumes/hpotter/.ssh/id_rsa",
                                 "hg" => "/Volumes/hgranger/.ssh/id_rsa"}}
      File.expects(:exist?).with(File.join(Dir.pwd, '.git-authors')).returns true
      YAML.expects(:load_file).with(File.join(Dir.pwd, '.git-authors')).returns initial_committers
      SSHSetup.any_instance.stubs(:ssh_add)
      File.stubs(:exist?).with("/Volumes/hpotter/.ssh/id_rsa").returns(true)
    end

    def test_login_calls_ssh_add
      ssh_setup = SSHSetup.new
      Time.stubs(:now).returns Time.new(2015, 9, 28, 6, 0)
      expected_ttl = 23400
      ssh_setup.expects(:ssh_add).with expected_ttl, "/Volumes/hpotter/.ssh/id_rsa"
      ssh_setup.login("hp")
    end

    def test_ssh_setup_looks_for_git_authors_in_any_parent_directory
      initial_committers = {"authors" => {"hp" => "Harry Potter", "hg" => "Hermione Granger"},
                            "emails" => {"hp" => "hpotter@pivotal.io", "hg" => "hgranger@pivotal.io"},
                            "sshkey_paths" =>
                                {"hp" => "/Volumes/hpotter/.ssh/id_rsa",
                                 "hg" => "/Volumes/hgranger/.ssh/id_rsa"}}


      current_dir_git_authors = File.join(Dir.pwd, '.git-authors')
      parent_dir_git_authors = File.join(File.expand_path('..', Dir.pwd), '.git-authors')
      File.unstub(:exist?)
      File.expects(:exist?).with(current_dir_git_authors).returns false
      File.expects(:exist?).with(parent_dir_git_authors).returns true

      YAML.unstub(:load_file)
      YAML.expects(:load_file).with(parent_dir_git_authors).returns initial_committers
      SSHSetup.new
    end

    def test_ssh_setup_fails_if_no_git_authors_found
      File.unstub(:exist?)
      YAML.unstub(:load_file)
      File.expects(:exist?).at_least_once.returns false
      error = assert_raises(Errno::ENOENT) {
        SSHSetup.new
      }
    end

    def test_login_sets_key_expiry_to_lunchtime_during_morning
      expected_expiration = Time.new(2015, 9, 28, 12, 30)
      ssh_setup = login_at Time.new(2015, 9, 28, 6, 0)
      assert_equal expected_expiration, ssh_setup.key_expiry
    end

    def test_login_sets_key_expiry_to_6pm_during_afternoon
      expected_expiration = Time.new(2015, 9, 28, 18, 0)
      ssh_setup = login_at(Time.new(2015, 9, 28, 13, 0))

      assert_equal expected_expiration, ssh_setup.key_expiry
    end

    def test_login_sets_key_expiry_to_within_15_minutes_as_default
      expected_expiration = Time.new(2015, 9, 28, 18, 15)
      ssh_setup = login_at(Time.new(2015, 9, 28, 18, 0))

      assert_equal expected_expiration, ssh_setup.key_expiry
    end

    def test_ssh_setup_displays_usage_when_initials_are_missing
      ssh_setup = SSHSetup.new
      error = assert_raises(ArgumentError) {
        ssh_setup.login(nil)
      }
      assert_match /Usage/, error.message
    end

    def test_ssh_setup_throws_exception_when_unable_to_find_initials
      ssh_setup = SSHSetup.new
      error = assert_raises(SSHSetup::UserNotFoundError) {
        ssh_setup.login("rw")
      }
      assert_match /Unable to find committer initials in mapping/, error.message
    end

    def test_login_throws_exception_when_unable_to_find_key_file
      File.expects(:exist?).with("/Volumes/hpotter/.ssh/id_rsa").returns(false)
      ssh_setup = SSHSetup.new
      error = assert_raises(Errno::ENOENT) {
        ssh_setup.login("hp")
      }
      # assert_match /Unable to find committer initials in mapping/, error.message
    end

    private

    def login_at(time)
      SSHSetup.new.tap do |ssh_setup|
        Time.stubs(:now).returns(time)
        ssh_setup.login("hp")
      end
    end
  end
end