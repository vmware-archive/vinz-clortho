module Clortho
  class UserNotFoundError < StandardError
  end

  class GitAuthorsManager
    def initialize
      @git_authors = YAML::load_file(git_authors_file)
    end

    def all_key_paths
      @git_authors['sshkey_paths'].values
    end

    def key_path_for(initials)
      raise ArgumentError.new(usage_msg) unless initials
      @git_authors['sshkey_paths'][initials] or raise UserNotFoundError.new(user_not_found_msg)
    end

    def usage_msg
      committers_and_keypaths = @git_authors['sshkey_paths'].map do |committer_initials, keypath|
        "\t#{committer_initials} : #{keypath}"
      end
      msg = <<-MSG
Usage: git ssh-login [options] (committer-initials)

known committers:
#{committers_and_keypaths.join("\n")}

If there is no mapping from your initials to your keypath, add it to .git-authors.
      MSG
    end

    private

    def git_authors_file(current_dir = Dir.pwd)
      git_authors_location = File.join(current_dir, '.git-authors')
      if File.exist?(git_authors_location)
        git_authors_location
      elsif current_dir == '/'
        raise Errno::ENOENT.new
      else
        git_authors_file(File.expand_path('..', current_dir))
      end
    end

    def user_not_found_msg
      "ERROR: Unable to find committer initials in mapping (check the \"sshkey_paths\" mapping for your initials)."
    end
  end
end