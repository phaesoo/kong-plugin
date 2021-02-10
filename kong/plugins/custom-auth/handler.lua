local http = require "resty.http"
local utils = require "kong.tools.utils"


local TokenHandler = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1",
}



-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.



-- handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function TokenHandler:init_worker()
  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end --]]



--[[ runs in the 'ssl_certificate_by_lua_block'
-- IMPORTANT: during the `certificate` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:certificate(conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")

end --]]



--[[ runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:rewrite(conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end --]]



-- runs in the 'access_by_lua_block'
function TokenHandler:access(conf)
  -- your custom code here
  kong.log.inspect(conf)   -- check the logs for a pretty-printed config!
  kong.service.request.set_header(conf.request_header, "this is on a request")

  local jwt_token = kong.request.get_header(conf.token_header)
  if not jwt_token then
    kong.response.exit(401)
  end

  kong.log.debug("jwt_token", jwt_token)
  kong.log.debug("ngx.request_uri", ngx.var.request_uri)
  kong.log.debug("kong.request.get_path()", kong.request.get_path())
  kong.log.debug("kong.request.get_raw_query()", kong.request.get_raw_query())

end --]]


-- runs in the 'header_filter_by_lua_block'
function TokenHandler:header_filter(conf)

  -- your custom code here, for example;
  kong.response.set_header(conf.response_header, "this is on the response")

end --]]


--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")

end --]]


--[[ runs in the 'log_by_lua_block'
function plugin:log(conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end --]]


-- return our plugin object
return TokenHandler
