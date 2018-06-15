defmodule ExJsonLogger.Transformer do
  @callback transform(metadata :: map()) :: map()
end
