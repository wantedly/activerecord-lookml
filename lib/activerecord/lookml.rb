require "activerecord/lookml/version"

module ActiveRecord
  module LookML
    class Error < StandardError; end
    # Your code goes here...
  end
end

ActiveSupport.on_load :active_record do
  require 'activerecord/lookml/core'
  ::ActiveRecord::Base.send :include, ActiveRecord::LookML::Core
end
