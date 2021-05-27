require 'active_support/all'
require "active_record/lookml"

ActiveSupport.on_load :active_record do
  require 'active_record/lookml/core'
  ActiveRecord::Base.include(ActiveRecord::LookML::Core)
end
