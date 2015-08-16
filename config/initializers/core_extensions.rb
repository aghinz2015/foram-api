require 'constraints/api_constraint'
require 'core_extensions/action_dispatch/routing'
require 'core_extensions/mongoid/attributes'

ActionDispatch::Routing::Mapper.send :include, CoreExtensions::ActionDispatch::Routing
Mongoid::Attributes.send :include, CoreExtensions::Mongoid::Attributes
