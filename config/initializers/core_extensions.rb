require "constraints/api_constraint"
require "core_extensions/action_dispatch/routing"

ActionDispatch::Routing::Mapper.send :include, CoreExtensions::ActionDispatch::Routing
