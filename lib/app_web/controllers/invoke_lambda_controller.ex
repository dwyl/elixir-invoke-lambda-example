defmodule AppWeb.InvokeLambdaController do

  def invoke(payload) do
    ExAws.Lambda.invoke("aws-ses-lambda-v1", payload, "no_context")
    |> ExAws.request(region: System.get_env("AWS_REGION"))
  end
end
