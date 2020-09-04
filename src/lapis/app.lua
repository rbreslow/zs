local lapis = require("lapis")
local db = require("lapis.db")

local app = lapis.Application()

app:get("/healthcheck", function()
  local res = db.query("SELECT * FROM information_schema.tables WHERE table_schema = ? AND table_type = ?", "public", "BASE TABLE")
  return {
    json = {"OK!"}
  }
end)

return app
