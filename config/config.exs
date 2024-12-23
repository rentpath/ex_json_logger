import Config

# This config is only here to keep Credo from complaining about missing
# metadata keys in the logger config.
config :logger, :default_formatter, metadata: [:pid, :ref, :user_id]
