require 'yaml'

require_relative 'git_authors_manager'

module Clortho
  class SSHSetup
    attr_reader :key_expiry

    def initialize
      @git_authors_mgr = GitAuthorsManager.new
    end

    def login(initials)
      set_key_expiry
      key_ttl = @key_expiry.to_i - Time.now.to_i
      key_path = @git_authors_mgr.key_path_for initials
      raise Errno::ENOENT.new unless File.exist? key_path
      ssh_add(key_ttl, key_path)
    end

    def login_all
      set_key_expiry
      key_ttl = @key_expiry.to_i - Time.now.to_i
      @git_authors_mgr.all_key_paths.each do |path|
        ssh_add(key_ttl, path) if File.exist?(path)
      end
    end

    def ssh_add(key_ttl, key_path)
      `ssh-add -t #{key_ttl} #{key_path}`
    end

    def usage_msg
      @git_authors_mgr.usage_msg
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
  end
end