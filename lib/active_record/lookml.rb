require 'active_support/all'
require "active_record/lookml/version"

module ActiveRecord
  module LookML
    class Error < StandardError; end
    # Your code goes here...
  end
end

ActiveSupport.on_load :active_record do
  require 'active_record/lookml/core'
  ::ActiveRecord::Base.send :include, ActiveRecord::LookML::Core
end
