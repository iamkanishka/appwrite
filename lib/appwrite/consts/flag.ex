defmodule Appwrite.Consts.Flag do
  @moduledoc """
  ISO 3166-1 alpha-2 country codes used by the Appwrite Avatars flag endpoint.

  Pass any value from `values/0` to `Appwrite.Services.Avatars.get_flag/4`.
  """

  use Appwrite.Consts.Behaviour,
    values: ~w(
      af ao al ad ae ar am ag au at az
      bi be bj bf bd bg bh bs ba by bz bo br bb bn bt bw
      cf ca ch cl cn ci cm cd cg co km cv cr cu cy cz
      de dj dm dk do dz
      ec eg er es ee et
      fi fj fr fm
      ga gb ge gh gn gm gw gq gr gd gt gy
      hn hr ht hu
      id in ie ir iq is il it
      jm jo jp
      kz ke kg kh ki kn kr kw kp
      la lb lr ly lc li lk ls lt lu lv
      ma mc md mg mv mx mh mk ml mt mm me mn mz mr mu mw my
      na ne ng ni nl no np nr nz
      om
      pk pa pe ph pw pg pl pf pt py
      qa
      ro ru rw
      sa sd sn sg sb sl sv sm so rs ss st sr sk si se sz sc sy
      td tg th tj tm tl to tt tn tr tv tz
      ug ua uy us uz
      va vc ve vn vu
      ws
      ye
      za zm zw
    ),
    name: "country flag"
end
