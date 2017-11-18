use Mix.Config

# For production, we configure the host to read the PORT from the system
# environment. Therefore, you will need to set PORT=80 before running your
# server.
#
# You should also configure the url host to something meaningful, we use this
# information when generating URLs.
#
# Finally, we also include the path to a manifest containing the digested
# version of static files. This manifest is generated by the mix phoenix.digest
# task which you typically run after static files are built.
config :homepage, HomepageWeb.Endpoint,
  http: [port: 4000],
  url: [host: "0.0.0.0", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json"
  #http: [port: 4000], url: [host: "localhost", port: 4000],
  #http: [host: "0.0.0.0", port: {:system, "PORT"}],
  #http: [port: {:system, "PORT"}],
  #url: [host: "0.0.0.0", port: 3000],

# Do not print debug messages in production
config :logger, level: :debug

secret_key_base = System.get_env "SECRET_KEY_BASE"
config :homepage, Homepage.Endpoint, secret_key_base: secret_key_base
config :guardian, Guardian, secret_key_base: secret_key_base

db_host = System.get_env("PGHOST") || "psql"
db_user = System.get_env "PGUSER"
db_pass = System.get_env "PGPASS"
db_port = System.get_env("PGPORT") || 5432

# Configure your database
config :homepage, Homepage.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: db_host,
  username: db_user,
  password: db_pass,
  port: db_port,
  database: "homepage_prod",
  pool_size: 20
