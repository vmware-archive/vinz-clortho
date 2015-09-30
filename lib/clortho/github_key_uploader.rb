require 'octokit'
require_relative 'git_authors_manager'

module Clortho
  class GitHubKeyUploader
    def initialize(initials, username, password)
      @manager = GitAuthorsManager.new
      @initials = initials
      @client = Octokit::Client.new(login: username, password: password)
    end

    def upload(title)
      key = File.open("#{@manager.key_path_for(@initials)}.pub", "r").read
      @client.add_key(title, key)
    end
  end
end
