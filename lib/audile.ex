defmodule Audile do

  @moduledoc "Parses albums and pulls their tracks for download"

  def parse(album) do
    get_page(album)
      |> find_tracks
  end

  def get_page(name) do
    HTTPoison.start
    page = HTTPoison.get! "https://downloads.khinsider.com/game-soundtracks/album/#{name}"
    page.body
  end

  def find_tracks(page) do
    page |> Floki.find("a[href*='.mp3'][style=''") |> build_tracklist
  end

  def build_tracklist(tracks) do
    Enum.map(tracks, fn el -> %{
      title: Floki.text(el),
      link: Floki.text(Floki.attribute(el, "href"))
    }
    end)
  end
end
