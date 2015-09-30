require 'minitest/autorun'
require 'mocha/mini_test'
require_relative '../../lib/clortho/github_key_uploader'

module Clortho
  class GitHubKeyUploaderTest < Minitest::Test
    def setup
      @initial_committers = {"authors" => {"hp" => "Harry Potter", "hg" => "Hermione Granger"},
                            "emails" => {"hp" => "hpotter@pivotal.io", "hg" => "hgranger@pivotal.io"},
                            "sshkey_paths" =>
                                {"hp" => "/Volumes/hpotter/.ssh/id_rsa",
                                 "hg" => "/Volumes/hgranger/.ssh/id_rsa"}}
      current_dir_git_authors = File.join(Dir.pwd, '.git-authors')
      YAML.expects(:load_file).with(current_dir_git_authors).returns @initial_committers
      File.expects(:exist?).with(current_dir_git_authors).returns true
    end

    def test_uploads_a_key
      uploader = GitHubKeyUploader.new('hp', 'hpotter', 'voldemort')
      client_mock = mock()
      client_mock.expects(:add_key).with('Secret Key', 'ssh-rsa AAA...')
      uploader.expects(:client).returns client_mock
      file_mock = mock()
      file_mock.expects(:read).returns 'ssh-rsa AAA...'
      File.expects(:open).with("/Volumes/hpotter/.ssh/id_rsa.pub", 'r').returns file_mock
      uploader.upload('Secret Key')
    end
  end
end
