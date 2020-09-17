local db = require("lapis.db")
local schema = require("lapis.db.schema")
local types = schema.types

return {
  [1598730685] = function()
    schema.create_table("maps", {
      { "id", types.varchar({primary_key = true}) },
      { "last_played", types.time({default = "-infinity"}) },
      { "installed", types.boolean({default = true}) }
    })
  end,
  [1599790650] = function()
    -- Initial commit of Howl.
    schema.create_table("player", {
      "\"id\" bigint",
      { "name", types.varchar({ null = true }) },
      { "role", types.varchar({ default = "user" }) },
      "\"updated_at\" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP",
      "PRIMARY KEY (\"id\")"
    })
    schema.create_index("player", "name")
    -- We need this in order to allow the developer Console to execute commands.
    db.insert("player", {
      id = -1,
      name = "Console",
      role = ""
    })
    schema.create_table("ban", {
      { "id", types.serial({ primary_key = true })},
      "\"player_id\" bigint",
      "\"banned_by\" bigint",
      "\"banned_at\" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP",
      { "expires_at", types.time },
      { "reason", types.varchar({ null = true }) },
      { "unbanned", types.boolean({default = false}) },
      "FOREIGN KEY (\"player_id\") REFERENCES \"public\".\"player\"(\"id\")",
      "FOREIGN KEY (\"banned_by\") REFERENCES \"public\".\"player\"(\"id\")"
    })
    schema.create_index("ban", "player_id", "expires_at", "unbanned")
    -- Modifications to existing map voting schema.
    schema.create_index("maps", "last_played", "installed")
  end
}
