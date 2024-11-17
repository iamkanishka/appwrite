defmodule Appwrite.Consts.Flag do
  @moduledoc """
  Provides constants and validation functions for country flags.

  This module defines the country flags by their ISO 3166-1 alpha-2 code and provides helper functions
  to validate them, ensuring only recognized country flags are used within the application.
  """

  @afghanistan "af"
  @angola "ao"
  @albania "al"
  @andorra "ad"
  @united_arab_emirates "ae"
  @argentina "ar"
  @armenia "am"
  @antigua_and_barbuda "ag"
  @australia "au"
  @austria "at"
  @azerbaijan "az"
  @burundi "bi"
  @belgium "be"
  @benin "bj"
  @burkina_faso "bf"
  @bangladesh "bd"
  @bulgaria "bg"
  @bahrain "bh"
  @bahamas "bs"
  @bosnia_and_herzegovina "ba"
  @belarus "by"
  @belize "bz"
  @bolivia "bo"
  @brazil "br"
  @barbados "bb"
  @brunei_darussalam "bn"
  @bhutan "bt"
  @botswana "bw"
  @central_african_republic "cf"
  @canada "ca"
  @switzerland "ch"
  @chile "cl"
  @china "cn"
  @cote_divoire "ci"
  @cameroon "cm"
  @democratic_republic_of_the_congo "cd"
  @republic_of_the_congo "cg"
  @colombia "co"
  @comoros "km"
  @cape_verde "cv"
  @costa_rica "cr"
  @cuba "cu"
  @cyprus "cy"
  @czech_republic "cz"
  @germany "de"
  @djibouti "dj"
  @dominica "dm"
  @denmark "dk"
  @dominican_republic "do"
  @algeria "dz"
  @ecuador "ec"
  @egypt "eg"
  @eritrea "er"
  @spain "es"
  @estonia "ee"
  @ethiopia "et"
  @finland "fi"
  @fiji "fj"
  @france "fr"
  @micronesia_federated_states_of "fm"
  @gabon "ga"
  @united_kingdom "gb"
  @georgia "ge"
  @ghana "gh"
  @guinea "gn"
  @gambia "gm"
  @guinea_bissau "gw"
  @equatorial_guinea "gq"
  @greece "gr"
  @grenada "gd"
  @guatemala "gt"
  @guyana "gy"
  @honduras "hn"
  @croatia "hr"
  @haiti "ht"
  @hungary "hu"
  @indonesia "id"
  @india "in"
  @ireland "ie"
  @iran_islamic_republic_of "ir"
  @iraq "iq"
  @iceland "is"
  @israel "il"
  @italy "it"
  @jamaica "jm"
  @jordan "jo"
  @japan "jp"
  @kazakhstan "kz"
  @kenya "ke"
  @kyrgyzstan "kg"
  @cambodia "kh"
  @kiribati "ki"
  @saint_kitts_and_nevis "kn"
  @south_korea "kr"
  @kuwait "kw"
  @lao_people_s_democratic_republic "la"
  @lebanon "lb"
  @liberia "lr"
  @libya "ly"
  @saint_lucia "lc"
  @liechtenstein "li"
  @sri_lanka "lk"
  @lesotho "ls"
  @lithuania "lt"
  @luxembourg "lu"
  @latvia "lv"
  @morocco "ma"
  @monaco "mc"
  @moldova "md"
  @madagascar "mg"
  @maldives "mv"
  @mexico "mx"
  @marshall_islands "mh"
  @north_macedonia "mk"
  @mali "ml"
  @malta "mt"
  @myanmar "mm"
  @montenegro "me"
  @mongolia "mn"
  @mozambique "mz"
  @mauritania "mr"
  @mauritius "mu"
  @malawi "mw"
  @malaysia "my"
  @namibia "na"
  @niger "ne"
  @nigeria "ng"
  @nicaragua "ni"
  @netherlands "nl"
  @norway "no"
  @nepal "np"
  @nauru "nr"
  @new_zealand "nz"
  @oman "om"
  @pakistan "pk"
  @panama "pa"
  @peru "pe"
  @philippines "ph"
  @palau "pw"
  @papua_new_guinea "pg"
  @poland "pl"
  @french_polynesia "pf"
  @north_korea "kp"
  @portugal "pt"
  @paraguay "py"
  @qatar "qa"
  @romania "ro"
  @russia "ru"
  @rwanda "rw"
  @saudi_arabia "sa"
  @sudan "sd"
  @senegal "sn"
  @singapore "sg"
  @solomon_islands "sb"
  @sierra_leone "sl"
  @el_salvador "sv"
  @san_marino "sm"
  @somalia "so"
  @serbia "rs"
  @south_sudan "ss"
  @sao_tome_and_principe "st"
  @suriname "sr"
  @slovakia "sk"
  @slovenia "si"
  @sweden "se"
  @eswatini "sz"
  @seychelles "sc"
  @syria "sy"
  @chad "td"
  @togo "tg"
  @thailand "th"
  @tajikistan "tj"
  @turkmenistan "tm"
  @timor_leste "tl"
  @tonga "to"
  @trinidad_and_tobago "tt"
  @tunisia "tn"
  @turkey "tr"
  @tuvalu "tv"
  @tanzania "tz"
  @uganda "ug"
  @ukraine "ua"
  @uruguay "uy"
  @united_states "us"
  @uzbekistan "uz"
  @vatican_city "va"
  @saint_vincent_and_the_grenadines "vc"
  @venezuela "ve"
  @vietnam "vn"
  @vanuatu "vu"
  @samoa "ws"
  @yemen "ye"
  @south_africa "za"
  @zambia "zm"
  @zimbabwe "zw"

  @all_flags [
    @afghanistan,
    @angola,
    @albania,
    @andorra,
    @united_arab_emirates,
    @argentina,
    @armenia,
    @antigua_and_barbuda,
    @australia,
    @austria,
    @azerbaijan,
    @burundi,
    @belgium,
    @benin,
    @burkina_faso,
    @bangladesh,
    @bulgaria,
    @bahrain,
    @bahamas,
    @bosnia_and_herzegovina,
    @belarus,
    @belize,
    @bolivia,
    @brazil,
    @barbados,
    @brunei_darussalam,
    @bhutan,
    @botswana,
    @central_african_republic,
    @canada,
    @switzerland,
    @chile,
    @china,
    @cote_divoire,
    @cameroon,
    @democratic_republic_of_the_congo,
    @republic_of_the_congo,
    @colombia,
    @comoros,
    @cape_verde,
    @costa_rica,
    @cuba,
    @cyprus,
    @czech_republic,
    @germany,
    @djibouti,
    @dominica,
    @denmark,
    @dominican_republic,
    @algeria,
    @ecuador,
    @egypt,
    @eritrea,
    @spain,
    @estonia,
    @ethiopia,
    @finland,
    @fiji,
    @france,
    @micronesia_federated_states_of,
    @gabon,
    @united_kingdom,
    @georgia,
    @ghana,
    @guinea,
    @gambia,
    @guinea_bissau,
    @equatorial_guinea,
    @greece,
    @grenada,
    @guatemala,
    @guyana,
    @honduras,
    @croatia,
    @haiti,
    @hungary,
    @indonesia,
    @india,
    @ireland,
    @iran_islamic_republic_of,
    @iraq,
    @iceland,
    @israel,
    @italy,
    @jamaica,
    @jordan,
    @japan,
    @kazakhstan,
    @kenya,
    @kyrgyzstan,
    @cambodia,
    @kiribati,
    @saint_kitts_and_nevis,
    @south_korea,
    @kuwait,
    @lao_people_s_democratic_republic,
    @lebanon,
    @liberia,
    @libya,
    @saint_lucia,
    @liechtenstein,
    @sri_lanka,
    @lesotho,
    @lithuania,
    @luxembourg,
    @latvia,
    @morocco,
    @monaco,
    @moldova,
    @madagascar,
    @maldives,
    @mexico,
    @marshall_islands,
    @north_macedonia,
    @mali,
    @malta,
    @myanmar,
    @montenegro,
    @mongolia,
    @mozambique,
    @mauritania,
    @mauritius,
    @malawi,
    @malaysia,
    @namibia,
    @niger,
    @nigeria,
    @nicaragua,
    @netherlands,
    @norway,
    @nepal,
    @nauru,
    @new_zealand,
    @oman,
    @pakistan,
    @panama,
    @peru,
    @philippines,
    @palau,
    @papua_new_guinea,
    @poland,
    @french_polynesia,
    @north_korea,
    @portugal,
    @paraguay,
    @qatar,
    @romania,
    @russia,
    @rwanda,
    @saudi_arabia,
    @sudan,
    @senegal,
    @singapore,
    @solomon_islands,
    @sierra_leone,
    @el_salvador,
    @san_marino,
    @somalia,
    @serbia,
    @south_sudan,
    @sao_tome_and_principe,
    @suriname,
    @slovakia,
    @slovenia,
    @sweden,
    @eswatini,
    @seychelles,
    @syria,
    @chad,
    @togo,
    @thailand,
    @tajikistan,
    @turkmenistan,
    @timor_leste,
    @tonga,
    @trinidad_and_tobago,
    @tunisia,
    @turkey,
    @tuvalu,
    @tanzania,
    @uganda,
    @ukraine,
    @uruguay,
    @united_states,
    @uzbekistan,
    @vatican_city,
    @saint_vincent_and_the_grenadines,
    @venezuela,
    @vietnam,
    @vanuatu,
    @samoa,
    @yemen,
    @south_africa,
    @zambia,
    @zimbabwe
  ]

  @doc """
  Guard clause to check if a given `flag` is a valid country flag code.

  ## Examples

      iex> Flag.valid_flag("in")
      true

      iex> Flag.valid_flag("xx")
      false
  """
  @spec valid_flag(String.t()) :: boolean()
  defguard valid_flag(flag) when flag in @all_flags

  @doc """
  Returns true if the given `flag` is a valid country flag code.

  ## Examples

      iex> Flag.is_valid_flag?("us")
      true

      iex> Flag.is_valid_flag?("xx")
      false
  """

  @spec is_valid_flag?(String.t()) :: boolean()
  def is_valid_flag?(flag), do: flag in @all_flags

  @doc """
  Validates the given `flag` and returns `{:ok, flag}` if it is valid,
  or `{:error, "Invalid country flag code"}` otherwise.

  ## Examples

      iex> Flag.validate_flag("ca")
      {:ok, "ca"}

      iex> Flag.validate_flag("xx")
      {:error, "Invalid country flag code"}
  """
  @spec validate_flag(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def validate_flag(flag) when flag in @all_flags, do: {:ok, flag}
  def validate_flag(_flag), do: {:error, "Invalid country flag code"}

  @doc """
  Returns the given `flag` if it is valid. Raises an `ArgumentError`
  if the `flag` is invalid.

  ## Examples

      iex> Flag.validate_flag!("fr")
      "fr"

      iex> Flag.validate_flag!("xx")
      ** (ArgumentError) Invalid country flag code: "xx"
  """
  @spec validate_flag!(String.t()) :: String.t()
  def validate_flag!(flag) do
    if flag in @all_flags do
      flag
    else
      raise ArgumentError, "Invalid country flag code: #{inspect(flag)}"
    end
  end
end
