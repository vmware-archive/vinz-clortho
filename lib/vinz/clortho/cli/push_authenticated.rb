module Vinz
  module Clortho
    module Cli

      class PushAuthenticated
        def perform *args
          SSHSetup.new.login_all(5)
          kernel.system "git push #{args.join(' ')}"
        end

        def kernel
          Kernel
        end
      end

    end
  end
end
