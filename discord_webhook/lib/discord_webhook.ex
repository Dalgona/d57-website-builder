defmodule DiscordWebhook do
  @moduledoc false

  status_codes =
    ~w(push build_start build_success build_failed deploy_start deploy_success deploy_failed all_done)

  status_code_atoms = Enum.map(status_codes, &String.to_atom/1)

  @type status_code ::
          unquote(
            status_code_atoms
            |> Enum.reverse()
            |> Enum.reduce(&quote(do: unquote(&1) | unquote(&2)))
          )

  @spec main([binary()]) :: any()
  def main(args)

  def main([arg]) when arg in unquote(status_codes) do
    webhook_id = System.get_env("DISCORD_WEBHOOK_ID")
    webhook_token = System.get_env("DISCORD_WEBHOOK_TOKEN")
    status_code = String.to_existing_atom(arg)

    request = %HTTPoison.Request{
      method: :post,
      url: webhook_url(webhook_id, webhook_token),
      body: json_payload(status_code),
      headers: [{"Content-Type", "application/json"}]
    }

    {:ok, %HTTPoison.Response{} = response} = HTTPoison.request(request)

    if response.status_code not in 200..299 do
      IO.puts(:stderr, [
        "Discord API server responded with the status code #{response.status_code}.",
        "\n\nResponse body:\n#{response.body}"
      ])

      System.halt(1)
    end
  end

  def main(_args) do
    IO.puts(:stderr, [
      "Expected exactly one argument, which is one of:\n",
      Enum.map(unquote(status_codes), &"\n    #{&1}")
    ])

    System.halt(2)
  end

  @spec webhook_url(binary(), binary()) :: binary()
  defp webhook_url(id, token), do: "https://discordapp.com/api/webhooks/#{id}/#{token}"

  @spec json_payload(status_code()) :: binary()
  defp json_payload(status_code) do
    ref = System.get_env("GITHUB_REF", "")
    sha = System.get_env("GITHUB_SHA", "")

    %{
      embeds: [
        %{
          title: embed_title(status_code),
          author: %{name: System.get_env("GITHUB_REPOSITORY", "")},
          color: embed_color(status_code),
          fields: [
            %{name: "Ref / Commit", value: "`#{ref}` @ `#{sha}`"}
            | extra_fields(status_code)
          ]
        }
      ]
    }
    |> Jason.encode!()
  end

  @spec embed_title(status_code()) :: binary()
  defp embed_title(status_code)
  defp embed_title(:push), do: "🚨 New commits were pushed 🚨"
  defp embed_title(:build_start), do: "Build job has started"
  defp embed_title(:build_success), do: "Build job has finished"
  defp embed_title(:build_failed), do: "Build job has finished"
  defp embed_title(:deploy_start), do: "Deployment job has started"
  defp embed_title(:deploy_success), do: "Deployment job has finished"
  defp embed_title(:deploy_failed), do: "Deployment job has finished"
  defp embed_title(:all_done), do: "🥰 All jobs have been completed successfully!"

  @spec embed_color(status_code()) :: integer()
  defp embed_color(status_code)
  defp embed_color(:push), do: 0xFFCC00
  defp embed_color(code) when code in ~w(build_start deploy_start)a, do: 0xCCFF00
  defp embed_color(code) when code in ~w(build_success deploy_success)a, do: 0x00FFCC
  defp embed_color(code) when code in ~w(build_failed deploy_failed)a, do: 0xFF8800
  defp embed_color(:all_done), do: 0x00CCFF

  @spec extra_fields(status_code()) :: [map()]
  defp extra_fields(status_code)
  defp extra_fields(:build_success), do: [%{name: "Status", value: "☺️ **SUCCESS**"}]
  defp extra_fields(:build_failed), do: [%{name: "Status", value: "😰 **FAILED**"}]
  defp extra_fields(:deploy_success), do: [%{name: "Status", value: "🚀 **SUCCESS**"}]
  defp extra_fields(:deploy_failed), do: [%{name: "Status", value: "💥 **FAILED**"}]
  defp extra_fields(_), do: []
end
