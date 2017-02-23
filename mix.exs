defmodule MixAuto.Mixfile do
  use Mix.Project

  def project do
    [app: :mix_auto,
     version: "0.0.1",
     elixir: "~> 1.0",
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
    Calls recompile anytime something inside lib/ changes.
    """
  end
end
