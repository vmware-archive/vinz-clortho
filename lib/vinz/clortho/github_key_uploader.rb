require 'octokit'

module Vinz
  module Clortho
    class GithubKeyUploader
      def initialize(initials, username, password)
        @manager = SSHKeyPathManager.new
        @initials = initials
        @username, @password = username, password
      end

      def upload(title)
        key = file.read
        client.add_key(title, key)
      end

      private

      def client
        @client ||= GithubClientWrapper.new(login: @username, password: @password)
      end

      def file
        @file ||= FileWrapper.open("#{@manager.key_path_for(@initials)}.pub", "r")
      end
    end
  end
end
