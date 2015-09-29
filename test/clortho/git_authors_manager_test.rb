require 'yaml'
require 'minitest/autorun'
require 'mocha/mini_test'
require_relative '../../lib/clortho/git_authors_manager'


module Clortho
  class GitAuthorsManagerTest < Minitest::Test
    def test_looks_for_git_authors_in_any_parent_directory
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
      GitAuthorsManager.new
    end

    def test_git_authors_manager_fails_if_no_git_authors_found
      File.unstub(:exist?)
      YAML.unstub(:load_file)
      File.expects(:exist?).at_least_once.returns false
      error = assert_raises(Errno::ENOENT) {
        GitAuthorsManager.new
      }
    end

    def test_key_path_for_throws_exception_when_unable_to_find_initials
      mgr = GitAuthorsManager.new
      error = assert_raises(UserNotFoundError) {
        mgr.key_path_for("rw")
      }
      assert_match /Unable to find committer initials in mapping/, error.message
    end

    def test_ssh_setup_displays_usage_when_initials_are_missing
      mgr = GitAuthorsManager.new
      error = assert_raises(ArgumentError) {
        mgr.key_path_for nil
      }
      assert_match /Usage/, error.message
    end
  end
end