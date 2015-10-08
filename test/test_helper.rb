$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vinz/clortho'

# This was included to get rid of an annoying warning about adding 'gem "minitest"' before 'require "minitest/autorun"'
gem 'minitest'

require 'minitest/autorun'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'yaml'
# require 'minitest/reporters'
# Minitest::Reporters.use!