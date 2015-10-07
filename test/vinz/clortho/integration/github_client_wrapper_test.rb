require 'test_helper'
require 'json'

module Vinz
  module Clortho
    class GithubClientWrapperTest < Minitest::Test
      def test_initialize
        wrapper = GithubClientWrapper.new(login: 'hpotter', password: 'password')
        client = wrapper.instance_variable_get(:@client)
        assert client.instance_of?(Octokit::Client)
        assert_equal 'hpotter', client.login
        assert_equal 'password', client.instance_variable_get(:@password)
      end

      def test_add_key
        name = 'hpotter'
        password = 'password'
        title = 'Secret key'
        key = 'ssh-rse AAA...'

        stub_request(:post, "https://#{name}:#{password}@api.github.com/user/keys")
            .with(body: {title: title, key: key}.to_json)
            .to_return(:status => 200, :body => 'successful body', :headers => {})
        wrapper = GithubClientWrapper.new(login: name, password: password)
        assert_equal 'successful body', wrapper.add_key(title, key)
      end
    end
  end
end