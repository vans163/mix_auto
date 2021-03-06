defmodule MixAuto.Mixfile do
  use Mix.Project

  def project do
    [app: :mix_auto,
     version: "0.0.1",
     elixir: "~> 1.4",
     package: package(),
     description: description(),
     deps: deps()]
  end

  def application do
    [applications: [:logger],
     mod: {MixAuto, []}]
  end

  defp deps, do: [{:inotify, git: "https://github.com/vans163/inotify.git"}]

  defp package do
    [
      licenses: ["Apache 2.0"],
      maintainers: ["vans163"],
      links: %{
        "GitHub" => "https://github.com/vans163/mix_auto"
      }
    ]
  end

  defp description do
    """
    Calls r/1 anytime a ".ex" file inside lib/ changes.
    """
  end
end
