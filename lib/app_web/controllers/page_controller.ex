defmodule AppWeb.PageController do
  use AppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def invoke do
    payload = %{
      name: "Elixir Lover",
      email: System.get_env("RECIPIENT_EMAIL"),
      template: "welcome"
    }
    ExAws.Lambda.invoke("aws-ses-lambda-v1", payload, "no_context")
    |> ExAws.request(region: System.get_env("AWS_REGION"))
  end

end
