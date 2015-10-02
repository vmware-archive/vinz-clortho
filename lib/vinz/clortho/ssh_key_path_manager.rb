require 'yaml'

module Vinz
  module Clortho
    class UserNotFoundError < StandardError
    end

    class KeyPathEntry
      attr_reader :initials, :path
      def initialize(path, initials = nil)
        @initials = initials
        @path = path
      end
    end

    class SSHKeyPathManager
      attr_reader :key_paths

      DEFAULT_KEY_PATH = '/Volumes/*/.ssh/id_rsa'

      def initialize
        @key_paths = if git_authors_file.nil?
          Dir[DEFAULT_KEY_PATH].map { |path| KeyPathEntry.new(path) }
        else
          git_authors = YAML::load_file(git_authors_file)
          git_authors['sshkey_paths'].map do |initials, path|
            KeyPathEntry.new(path, initials)
          end
        end
      end

      def key_path_for(initials)
        raise ArgumentError.new('Committer initials are required') unless initials
        key_path = @key_paths.detect { |kp| kp.initials == initials }
        if key_path.nil?
          raise UserNotFoundError.new(user_not_found_msg)
        else
          key_path.path
        end
      end

      private

      def git_authors_file(current_dir = Dir.pwd)
        @git_authors_file ||= begin
          git_authors_location = File.join(current_dir, '.git-authors')
          if File.exist?(git_authors_location)
            git_authors_location
          elsif current_dir == '/'
            nil
          else
            git_authors_file(File.expand_path('..', current_dir))
          end
        end
      end

      def user_not_found_msg
        "ERROR: Unable to find committer initials in .git-authors (check the \"sshkey_paths\" mapping for your initials)."
      end
    end
  end
end