local http = require "resty.http"
local json = require "cjson"

local TokenHandler = {
  PRIORITY = 1000,
  VERSION = "0.1",
}

function TokenHandler:access(conf)
  kong.log.inspect(conf)

  local jwt_token = kong.request.get_header(conf.token_header)
  if not jwt_token then
    kong.log.debug("Token not found in header")
    kong.response.exit(401)
  end

  local token_type = jwt_token:sub(8,-1)
  if token_type ~= "Bearer " then
    kong.log.debug("Invalid token type: ", token_type)
    kong.response.exit(401)
  end

  local httpc = http:new()
  httpc.connect(conf.authorization_host, conf.authorization_port)

  local res, err = httpc.request({
    method = "POST",
    path = "/apikey/verify",
    headers = {
      ["Content-Type"] = "application/json",
      [conf.token_header] = jwt_token,
    },
    body = json.encode({
      path = kong.request.get_path(),
      raw_query = kong.request.get_raw_query(),
    }),
  })

  if not res then
    kong.log.err("Failed to call authorization_endpoint:", err)
    return kong.response.exit(500)
  end

  if res.status ~= 200 then
    kong.log.debug("Failed to authenticate", json.decode(res.body))
    return kong.response.exit(401) -- unauthorized
  end
end

return TokenHandler
