require 'rails'
require 'action_controller'

class TestApplication < Rails::Application; end
Rails.application.routes.draw do
  resources :cruds, :responders
end
require 'rails/test_help'

require 'admin_controller'
require 'minitest/autorun'
require 'debugger'
