defmodule Chat.Mixfile do
  use Mix.Project

  def project() do
    [app: :chat,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application() do
    [mod: {Chat, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :ecto, :postgrex]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps() do
    [{:phoenix, "~> 1.2"},
     {:phoenix_html, "~> 2.5"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:postgrex, "~> 0.13"},
     {:ecto, "~> 2.0"},
     {:calendar, "~> 0.17"},
     {:cowboy, "~> 1.0"}]
  end
end
