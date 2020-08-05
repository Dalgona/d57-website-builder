defmodule DiscordWebhook.MixProject do
  use Mix.Project

  def project do
    [
      app: :discord_webhook,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: DiscordWebhook]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.7"}
    ]
  end
end
