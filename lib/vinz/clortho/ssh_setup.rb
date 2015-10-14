module Vinz
  module Clortho
    class UnableToLoginError < StandardError
    end

    class SSHSetup
      attr_reader :key_expiry

      def initialize
        @ssh_key_path_mgr = SSHKeyPathManager.new
      end

      def login(initials = nil)
        set_key_expiry
        key_ttl = @key_expiry.to_i - Time.now.to_i
        if initials.nil?
          login_all key_ttl
        else
          key_path = @ssh_key_path_mgr.key_path_for initials
          ssh_add(key_ttl, key_path)
        end
      end

      def login_all(key_ttl = nil)
        if key_ttl.nil?
          set_key_expiry
          key_ttl = @key_expiry.to_i - Time.now.to_i
        end

        raise UnableToLoginError.new('no key paths available') unless @ssh_key_path_mgr.key_paths.any?

        @ssh_key_path_mgr.key_paths.each do |key_path|
          path = key_path.path
          ssh_add(key_ttl, path) if File.exist?(path)
        end
      end

      def ssh_add(key_ttl, key_path)
        raise UnableToLoginError.new(Errno::ENOENT.new) unless File.exist? key_path
        `ssh-add -t #{key_ttl} #{key_path}`
      end

      def usage_msg
        committers_and_keypaths = @ssh_key_path_mgr.key_paths.map do |key_path|
          "\t#{key_path.initials} : #{key_path.path}"
        end
        msg = <<-MSG
Usage: git ssh-login [options] [committer-initials]

known committers:
#{committers_and_keypaths.join("\n")}

If there is no mapping from your initials to your keypath, add it to .git-authors.
        MSG
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
end