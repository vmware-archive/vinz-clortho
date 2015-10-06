require 'io/console'

module Vinz
  module Clortho
    module Cli
      class SSHLogin
        def kernel
          Kernel
        end

        def perform(initials)
          setup = SSHSetup.new
          setup.login(initials)
        end

        def add_to_github initials
          kernel.print "Enter your username: "
          username = kernel.gets.chomp
          kernel.print "Enter your password: "
          password = STDIN.noecho(&:gets).chomp

          puts # because previous line of code doesn't insert newline
          uploader = Vinz::Clortho::GithubKeyUploader.new(initials, username, password)
          kernel.print "Enter title for key: "
          title = kernel.gets.chomp
          uploader.upload title
        end
      end
    end
  end
end
