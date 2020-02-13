defmodule AppWeb.InvokeLambdaController do

  @doc """
  `invoke/1` uses ExAws.Lambda.invoke to invoke our aws-ses-lambda-v1 function.
  """
  def invoke(payload) do
    ExAws.Lambda.invoke("aws-ses-lambda-v1", payload, "no_context")
    |> ExAws.request(region: System.get_env("AWS_REGION"))
  end
end
