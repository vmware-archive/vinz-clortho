require 'octokit'

module Vinz
  module Clortho
    class GitHubKeyUploader
      def initialize(initials, username, password)
        @manager = GitAuthorsManager.new
        @initials = initials
        @username, @password = username, password
      end

      def upload(title)
        key = File.open("#{@manager.key_path_for(@initials)}.pub", "r").read
        client.add_key(title, key)
      end

      private
      def client
        @client ||= Octokit::Client.new(login: @username, password: @password)
      end
    end
  end
end