# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'dashamail'

require 'minitest/autorun'
require 'minitest/mock'
require 'webmock/minitest'
require_relative '../lib/dashamail_transactional'

module TestSetup
  def self.setup
    DashaMail.configure do |config|
      config.api_key    = '123123'
      config.domain     = 'test.test'
      config.from_email = 'marketing@my-domain.ru'
      config.from_name  = 'Отдел маркетинга'
      config.ignore_delivery_policy = true
      config.no_track_clicks = true
      config.no_track_opens = false
    end
  end
end

TestSetup.setup
