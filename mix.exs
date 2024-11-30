defmodule Appwrite.MixProject do
  use Mix.Project

  @source_url "https://github.com/iamkanishka/appwrite"
  @version "0.1.7"

  def project do
    [
      app: :appwrite,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      # Package information for Hex
      description: "Appwrite package for elixir",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Appwrite.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:poison, "~> 6.0"},
      {:uuid, "~> 1.1"}
    ]
  end

  defp package do
    [
      name: "appwrite",
      # License, e.g., MIT, Apache 2.0
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url,
        Website: "https://kanishkanaik.dev/",
        Changelog: "#{@source_url}/blob/master/CHANGELOG.md",
        GitHub: @source_url,
        Docs: "https://hexdocs.pm/appwrite",
        Twitter: "https://x.com/NaikKanishk1831",
        Medium: "https://medium.com/@kanishkanaik97",
        Linkedin: "https://www.linkedin.com/in/kanishka-naik-kannu-6b5180191/"
      },
      maintainers: ["Kanishka Naik"]
    ]
  end

  defp docs do
    [
      main: "Appwrite",
      api_reference: false,
      # logo: "assets/oban-logo.svg",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extra_section: "GUIDES",
      formatters: ["html"],
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules(),
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp extras do
    [
      # Introduction
      "guides/introduction/installation.md",
      "CHANGELOG.md": [title: "Changelog"]
    ]
  end

  defp groups_for_extras do
    [
      Introduction: ~r{guides/introduction/[^\/]+\.md}
      # Learning: ~r{guides/learning/[^\/]+\.md},
      # Advanced: ~r{guides/advanced/[^\/]+\.md},
      # Recipes: ~r{guides/recipes/.?},
      # Testing: ~r{guides/testing/.?},
      # "Upgrade Guides": ~r{guides/upgrading/.*}
    ]
  end

  defp groups_for_modules do
    [
      Services: [
        Appwrite.Services.Accounts,
        Appwrite.Services.Avatars,
        Appwrite.Services.Database,
        Appwrite.Services.Functions,
        Appwrite.Services.Locale,
        Appwrite.Services.Messaging,
        Appwrite.Services.Storage,
        Appwrite.Services.Teams
      ],
      Utils: [
        Appwrite.Utils.Id,
        Appwrite.Utils.Permission,
        Appwrite.Utils.Query,
        Appwrite.Utils.Role,
        Appwrite.Utils.Client,
        Appwrite.Utils.Service,
        Appwrite.Utils.General

      ],
      Consts: [
        Appwrite.Consts.AuthenticationFactor,
        Appwrite.Consts.AuthenticationType,
        Appwrite.Consts.Browsers,
        Appwrite.Consts.CreditCard,
        Appwrite.Consts.ExecutionMethod,
        Appwrite.Consts.Flag,
        Appwrite.Consts.ImageFormat,
        Appwrite.Consts.ImageGravity,
        Appwrite.Consts.OAuthProvider
      ],
      Types: [
        Appwrite.Types.AlgoArgon2,
        Appwrite.Types.AlgoBcrypt,
        Appwrite.Types.AlgoMd5,
        Appwrite.Types.AlgoPhpass,
        Appwrite.Types.AlgoScryptModified,
        Appwrite.Types.AlgoSha,
        Appwrite.Types.Continent,
        Appwrite.Types.ContinentList,
        Appwrite.Types.Country,
        Appwrite.Types.CountryList,
        Appwrite.Types.Currency,
        Appwrite.Types.CurrencyList,
        Appwrite.Types.Document,
        Appwrite.Types.DocumentList,
        Appwrite.Types.Execution,
        Appwrite.Types.ExecutionList,
        Appwrite.Types.File,
        Appwrite.Types.FileList,
        Appwrite.Types.Headers,
        Appwrite.Types.Headers,
        Appwrite.Types.Identity,
        Appwrite.Types.IdentityList,
        Appwrite.Types.Jwt,
        Appwrite.Types.Language,
        Appwrite.Types.LanguageList,
        Appwrite.Types.LocaleCode,
        Appwrite.Types.LocaleCodeList,
        Appwrite.Types.Locale,
        Appwrite.Types.Log,
        Appwrite.Types.LogList,
        Appwrite.Types.Membership,
        Appwrite.Types.MembershipList,
        Appwrite.Types.MfaChallenge,
        Appwrite.Types.MfaFactors,
        Appwrite.Types.MfaRecoveryCodes,
        Appwrite.Types.MfaType,
        Appwrite.Types.Phone,
        Appwrite.Types.PhoneList,
        Appwrite.Types.Preference,
        Appwrite.Types.Session,
        Appwrite.Types.SessionList,
        Appwrite.Types.Target,
        Appwrite.Types.Team,
        Appwrite.Types.TeamList,
        Appwrite.Types.Token,
        Appwrite.Types.User,
        Appwrite.Types.Client.Headers,
        Appwrite.Types.Client.Payload,
        Appwrite.Types.Client.Realtime,
        Appwrite.Types.Client.RealtimeRequest,
        Appwrite.Types.Client.RealtimeRequestAuthenticate,
        Appwrite.Types.Client.RealtimeResponse,
        Appwrite.Types.Client.RealtimeResponseAuthenticated,
        Appwrite.Types.Client.RealtimeResponseConnected,
        Appwrite.Types.Client.RealtimeResponseError,
        Appwrite.Types.Client.RealtimeResponseEvent,
        Appwrite.Types.Client.UploadProgress
      ]
    ]
  end
end
