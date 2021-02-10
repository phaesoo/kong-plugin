local typedefs = require "kong.db.schema.typedefs"

-- Grab pluginname from module name
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

local schema = {
  name = plugin_name,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          {
            authorization_host = {
              type = "string",
              default = "testapi.testapi",
              required = true,
            },
          },
          {
            authorization_port = {
              type = "integer",
              default = 8080,
              required = true,
            },
          },
          {
            token_header = typedefs.header_name {
              default = "Authorization",
              required = true
            },
          }
        },
        entity_checks = {
        },
      },
    },
  },
}

return schema
