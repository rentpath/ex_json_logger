defmodule ExJsonLogger.Transformer.Identity do
  @behaviour ExJsonLogger.Transformer

  @impl true
  def transform(metadata), do: metadata
end
