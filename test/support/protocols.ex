defmodule StringCharsValue do
  @moduledoc false
  defstruct [:message]

  defimpl String.Chars do
    @impl true
    def to_string(%{message: message}) do
      "StringCharsValue says: " <> message
    end
  end
end

defmodule JasonEncoderValue do
  @moduledoc false
  @derive {Jason.Encoder, only: [:message]}
  defstruct [:message, :secret]
end

defmodule InspectValue do
  @moduledoc false
  @derive {Inspect, only: [:message]}
  defstruct [:message, :secret]
end
