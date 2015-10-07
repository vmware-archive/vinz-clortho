module Vinz
  module Clortho
    class GithubClientWrapper
      def initialize(options = {})
        @client = Octokit::Client.new(login: options[:login], password: options[:password])
      end

      def add_key(title, key)
        @client.add_key(title, key)
      end
    end
  end
end