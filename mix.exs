defmodule Appwrite.MixProject do
  use Mix.Project

  @source_url "https://github.com/iamkanishka/appwrite"
  @version "0.2.0"

  def project do
    [
      app: :appwrite,
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      description:
        "Elixir SDK for the Appwrite backend-as-a-service platform. " <>
          "Supports authentication, databases, storage, functions, teams, messaging, and more.",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Appwrite.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.28", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      name: "appwrite",
      licenses: ["Apache-2.0"],
      links: %{
        GitHub: @source_url,
        Docs: "https://hexdocs.pm/appwrite",
        Changelog: "#{@source_url}/blob/master/CHANGELOG.md"
      },
      maintainers: ["Kanishka Naik"]
    ]
  end

  defp docs do
    [
      main: "Appwrite",
      api_reference: false,
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
      "guides/introduction/installation.md",
      "CHANGELOG.md": [title: "Changelog"]
    ]
  end

  defp groups_for_extras do
    [
      Introduction: ~r{guides/introduction/[^\/]+\.md}
    ]
  end

  defp groups_for_modules do
    [
      Services: [
        Appwrite.Services.Accounts,
        Appwrite.Services.Avatars,
        Appwrite.Services.Database,
        Appwrite.Services.Functions,
        Appwrite.Services.GraphQL,
        Appwrite.Services.Health,
        Appwrite.Services.Locale,
        Appwrite.Services.Messaging,
        Appwrite.Services.Storage,
        Appwrite.Services.Teams
      ],
      Utils: [
        Appwrite.Utils.Client,
        Appwrite.Utils.General,
        Appwrite.Utils.Id,
        Appwrite.Utils.Permission,
        Appwrite.Utils.Query,
        Appwrite.Utils.Role,
        Appwrite.Utils.Service
      ],
      Consts: [
        Appwrite.Consts.AuthenticationFactor,
        Appwrite.Consts.AuthenticationType,
        Appwrite.Consts.Browser,
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
        Appwrite.Types.AlgoScrypt,
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
        Appwrite.Types.HealthAntivirus,
        Appwrite.Types.HealthCertificate,
        Appwrite.Types.HealthQueue,
        Appwrite.Types.HealthStatus,
        Appwrite.Types.HealthTime,
        Appwrite.Types.Identity,
        Appwrite.Types.IdentityList,
        Appwrite.Types.Jwt,
        Appwrite.Types.Language,
        Appwrite.Types.LanguageList,
        Appwrite.Types.Locale,
        Appwrite.Types.LocaleCode,
        Appwrite.Types.LocaleCodeList,
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
        Appwrite.Types.Subscriber,
        Appwrite.Types.Target,
        Appwrite.Types.Team,
        Appwrite.Types.TeamList,
        Appwrite.Types.Token,
        Appwrite.Types.User,
        Appwrite.Types.Client.Config,
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
