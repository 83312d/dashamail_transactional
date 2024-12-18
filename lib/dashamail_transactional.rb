# frozen_string_literal: true

require 'dashamail/version'
require 'dashamail/configuration'
require 'dashamail/utils'
require 'dashamail/http'
require 'dashamail/composer'
require 'dashamail/mailer'
require 'dashamail/response'
require 'dashamail/request'

module DashamailTransactional
  def self.configure
    yield DashamailTransactional::Configuration
  end

  def self.config
    DashamailTransactional::Configuration
  end
end

DashaMail = DashamailTransactional
