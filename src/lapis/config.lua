local config = require "lapis.config"

config("development", {
  port = os.getenv("PORT"),
  postgres = {
    host = os.getenv("POSTGRES_HOST"),
    user = os.getenv("POSTGRES_USER"),
    password = os.getenv("POSTGRES_PASSWORD"),
    database = os.getenv("POSTGRES_DB")
  }
})
