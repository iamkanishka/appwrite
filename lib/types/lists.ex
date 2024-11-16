defmodule Appwrite.Types.Lists do
  @moduledoc """
  Represents different list types returned by Appwrite, including counts and arrays of items.
  """

  defmodule DocumentList do
    @moduledoc """
    Represents a list of documents.

    ## Fields

      - `total` (`integer`): Total number of documents that matched the query.
      - `documents` (`[Document]`): List of documents.
    """

    @type t :: %__MODULE__{
            total: integer(),
            documents: [Appwrite.Types.Document.t()]
          }

    defstruct [:total, :documents]
  end

  defmodule SessionList do
    @moduledoc """
    Represents a list of sessions.

    ## Fields

      - `total` (`integer`): Total number of sessions that matched the query.
      - `sessions` (`[Appwrite.Types.Session.t]`): List of sessions.
    """

    @type t :: %__MODULE__{
            total: integer(),
            sessions: [Appwrite.Types.Session.t()]
          }

    defstruct [:total, :sessions]
  end

  defmodule IdentityList do
    @moduledoc """
    Represents a list of identities.

    ## Fields

      - `total` (`integer`): Total number of identities that matched the query.
      - `identities` (`[Appwrite.Types.Identity.t]`): List of identities.
    """

    @type t :: %__MODULE__{
            total: integer(),
            identities: [Appwrite.Types.Identity.t()]
          }

    defstruct [:total, :identities]
  end

  defmodule LogList do
    @moduledoc """
    Represents a list of logs.

    ## Fields

      - `total` (`integer`): Total number of logs that matched the query.
      - `logs` (`[Appwrite.Types.Log.t]`): List of logs.
    """

    @type t :: %__MODULE__{
            total: integer(),
            logs: [Appwrite.Types.Log.t()]
          }

    defstruct [:total, :logs]
  end

  defmodule FileList do
    @moduledoc """
    Represents a list of files.

    ## Fields

      - `total` (`integer`): Total number of files that matched the query.
      - `files` (`[Appwrite.Types.File.t]`): List of files.
    """

    @type t :: %__MODULE__{
            total: integer(),
            files: [Appwrite.Types.File.t()]
          }

    defstruct [:total, :files]
  end

  defmodule MembershipList do
    @moduledoc """
    Represents a list of memberships.

    ## Fields

      - `total` (`integer`): Total number of memberships that matched the query.
      - `memberships` (`[Appwrite.Types.Membership.t]`): List of memberships.
    """

    @type t :: %__MODULE__{
            total: integer(),
            memberships: [Appwrite.Types.Membership.t()]
          }

    defstruct [:total, :memberships]
  end

  defmodule ExecutionList do
    @moduledoc """
    Represents a list of executions.

    ## Fields

      - `total` (`integer`): Total number of executions that matched the query.
      - `executions` (`[Appwrite.Types.Execution.t]`): List of executions.
    """

    @type t :: %__MODULE__{
            total: integer(),
            executions: [Appwrite.Types.Execution.t()]
          }

    defstruct [:total, :executions]
  end

  defmodule CountryList do
    @moduledoc """
    Represents a list of countries.

    ## Fields

      - `total` (`integer`): Total number of countries that matched the query.
      - `countries` (`[Appwrite.Types.Country.t]`): List of countries.
    """

    @type t :: %__MODULE__{
            total: integer(),
            countries: [Appwrite.Types.Country.t()]
          }

    defstruct [:total, :countries]
  end

  defmodule ContinentList do
    @moduledoc """
    Represents a list of continents.

    ## Fields

      - `total` (`integer`): Total number of continents that matched the query.
      - `continents` (`[Appwrite.Types.Continent.t]`): List of continents.
    """

    @type t :: %__MODULE__{
            total: integer(),
            continents: [Appwrite.Types.Continent.t()]
          }

    defstruct [:total, :continents]
  end

  defmodule LanguageList do
    @moduledoc """
    Represents a list of languages.

    ## Fields

      - `total` (`integer`): Total number of languages that matched the query.
      - `languages` (`[Appwrite.Types.Language.t]`): List of languages.
    """

    @type t :: %__MODULE__{
            total: integer(),
            languages: [Appwrite.Types.Language.t()]
          }

    defstruct [:total, :languages]
  end

  defmodule CurrencyList do
    @moduledoc """
    Represents a list of currencies.

    ## Fields

      - `total` (`integer`): Total number of currencies that matched the query.
      - `currencies` (`[Appwrite.Types.Currency.t]`): List of currencies.
    """

    @type t :: %__MODULE__{
            total: integer(),
            currencies: [Appwrite.Types.Currency.t()]
          }

    defstruct [:total, :currencies]
  end

  defmodule PhoneList do
    @moduledoc """
    Represents a list of phones.

    ## Fields

      - `total` (`integer`): Total number of phones that matched the query.
      - `phones` (`[Appwrite.Types.Phone.t]`): List of phones.
    """

    @type t :: %__MODULE__{
            total: integer(),
            phones: [Appwrite.Types.Phone.t()]
          }

    defstruct [:total, :phones]
  end

  defmodule TeamList do
    @moduledoc """
    Represents a list of teams.

    ## Fields

      - `total` (`integer`): Total number of teams that matched the query.
      - `teams` (`[Appwrite.Types.Team.t]`): List of teams.
    """

    @type t :: %__MODULE__{
            total: integer(),
            teams: [Appwrite.Types.Team.t()]
          }

    defstruct [:total, :teams]
  end

  defmodule LocaleCodeList do
    @moduledoc """
    Represents a list of locale codes.

    ## Fields

      - `total` (`integer`): Total number of locale codes that matched the query.
      - `locale_codes` (`[Appwrite.Types.LocaleCode.t]`): List of locale codes.
    """

    @type t :: %__MODULE__{
            total: integer(),
            locale_codes: [Appwrite.Types.LocaleCode.t()]
          }

    defstruct [:total, :locale_codes]
  end
end
