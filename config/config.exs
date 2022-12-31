import Config

config :duper,
  dir_walker: DirWalker,
  hasher: Duper.Hasher

import_config "#{config_env()}.exs"
