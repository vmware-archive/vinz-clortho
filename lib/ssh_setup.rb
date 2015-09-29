require 'yaml'

class SSHSetup
  attr_reader :key_expiry

  class UserNotFoundError < StandardError
  end

  def initialize(initials)
    @scriptname = File.basename(__FILE__)
    git_authors = YAML::load_file(git_authors_file)
    @key_paths = git_authors['sshkey_paths']
    @key_path = @key_paths[initials]
    raise ArgumentError.new(usage_msg) unless initials
    raise UserNotFoundError.new(user_not_found_msg) unless @key_path
  end

  def login
    set_key_expiry
    key_ttl = @key_expiry.to_i - Time.now.to_i
    raise Errno::ENOENT.new unless File.exist? @key_path
    ssh_add(key_ttl, @key_path)
  end

  def ssh_add(key_ttl, key_path)
    `ssh-add -t #{key_ttl} #{key_path}`
  end

  private
  def set_key_expiry
    now = Time.now
    lunchtime = Time.new(now.year, now.month, now.day, 12, 30)
    end_of_day = Time.new(now.year, now.month, now.day, 18, 0)
    in_fifteen_minutes = now + (60 * 15)

    @key_expiry = if now < lunchtime
      lunchtime
    elsif now < end_of_day
      end_of_day
    else
      in_fifteen_minutes
    end
  end

  def git_authors_file(current_dir = Dir.pwd)
    git_authors_location = File.join(current_dir, '.git-authors')
    if File.exist?(git_authors_location)
      git_authors_location
    else
      git_authors_file(File.expand_path('..', current_dir))
    end
  end

  def user_not_found_msg
    "ERROR: Unable to find committer initials in mapping (check the \"sshkey_paths\" mapping for your initials).\n" + usage_msg
  end

  def usage_msg
    committers_and_keypaths = @key_paths.map do |committer_initials, keypath|
      "\t#{committer_initials} : #{keypath}"
    end
    msg = <<-MSG
      Usage:
        #{@scriptname} (committer-initials)

      known committers:
#{committers_and_keypaths.join("\n")}

      If there is no mapping from your initials to your keypath, add it to .git-authors.
    MSG
  end
end