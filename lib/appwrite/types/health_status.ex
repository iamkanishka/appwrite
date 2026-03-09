defmodule Appwrite.Types.HealthStatus do
  @moduledoc """
  Represents the health status of an Appwrite service component.

  ## Fields

    - `name` (`String.t()`): Name of the service being checked.
    - `ping` (`non_neg_integer()`): Response time in milliseconds (round trip).
    - `status` (`String.t()`): Current health status. One of `"pass"` or `"fail"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          ping: non_neg_integer(),
          status: String.t()
        }

  defstruct [:name, :ping, :status]
end

defmodule Appwrite.Types.HealthAntivirus do
  @moduledoc """
  Represents the health status of the Appwrite antivirus service.

  ## Fields

    - `version` (`String.t()`): Antivirus version.
    - `status` (`String.t()`): Antivirus status. One of `"disabled"`, `"offline"`, `"online"`.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          version: String.t(),
          status: String.t()
        }

  defstruct [:version, :status]
end

defmodule Appwrite.Types.HealthQueue do
  @moduledoc """
  Represents the size of an Appwrite internal queue.

  ## Fields

    - `size` (`non_neg_integer()`): Number of actions currently in the queue.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          size: non_neg_integer()
        }

  defstruct [:size]
end

defmodule Appwrite.Types.HealthTime do
  @moduledoc """
  Represents the result of a server time check against Google's NTP server.

  ## Fields

    - `remote_time` (`non_neg_integer()`): Current time of the remote NTP server (Unix timestamp).
    - `local_time` (`non_neg_integer()`): Current time of the Appwrite server (Unix timestamp).
    - `diff` (`integer()`): Difference in milliseconds between the remote NTP server and the Appwrite server.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          remote_time: non_neg_integer(),
          local_time: non_neg_integer(),
          diff: integer()
        }

  defstruct [:remote_time, :local_time, :diff]
end

defmodule Appwrite.Types.HealthCertificate do
  @moduledoc """
  Represents an SSL certificate health check result.

  ## Fields

    - `name` (`String.t()`): Certificate name (domain).
    - `subject` (`String.t()`): Certificate subject.
    - `valid_from` (`String.t()`): Certificate validity start date.
    - `valid_till` (`String.t()`): Certificate validity end date.
    - `cn` (`String.t()`): Certificate common name.
  """

  @derive Jason.Encoder

  @type t :: %__MODULE__{
          name: String.t(),
          subject: String.t(),
          valid_from: String.t(),
          valid_till: String.t(),
          cn: String.t()
        }

  defstruct [:name, :subject, :valid_from, :valid_till, :cn]
end
