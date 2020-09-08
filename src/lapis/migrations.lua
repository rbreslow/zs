local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1598730685] = function()
    schema.create_table("maps", {
      { "id", types.varchar({primary_key = true})},
      { "last_played", types.time({default = "-infinity"}) },
      { "installed", types.boolean({default = true}) },
    })
  end
}
