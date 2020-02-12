<div align="center">

# `Elixir` Invoke `Lambda` _Example_ λ

A basic example showing how to invoke AWS Lambda functions
from Elixir/Phoenix Apps.

<!--
[![Build Status](https://img.shields.io/travis/dwyl/aws-lambda-deploy/master.svg?style=flat-square)](https://travis-ci.org/dwyl/aws-lambda-deploy)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/aws-lambda-deploy/master.svg?style=flat-square)](http://codecov.io/github/dwyl/aws-lambda-deploy?branch=master)
[![HitCount](http://hits.dwyl.com/dwyl/aws-lambda-deploy.svg)](http://hits.dwyl.com/dwyl/aws-lambda-deploy)
-->

</div>
<br />

## Why? 🤷‍

To keep our Elixir/Phoenix App
as _focussed_ as possible,
we are ***delegating*** all
of the **_non-core_ functionality**
to **AWS Lambda** functions.
AWS Lambda will allow us
to offload specific non-core functionality
such as sending/receiving emails and
uploading/resizing/transcoding images/video.
This non-core functionality
still needs to work _flawlessly_
but it will not be invoked directly by end-users.
Rather the Lambda functions
will be invoked asynchronously
by our Elixir/Phoenix
with as little overhead as possible.

If keeping your app _focussed_
sounds like a good idea to you,
follow along with the adventure!


## What? 💭

This example invokes our
[**`aws-ses-lambda`**](https://github.com/dwyl/aws-ses-lambda)
function that handles all our **`email`** needs.

The example is a _step-by-step_ implementation,
designed to help _anyone_ follow along.


## Who? 👤

This example is targeted at Elixir/Phoenix _novices_
who are hoping to leverage the power of "serverless",
to run specific bits of non-core functionality.


## How? 👩‍💻

This is a _complete_ build log for getting this working.
We hope that it's useful to others.

### 0. Prerequisites? ✅

If you already have a bit of Elixir/Phoenix knowledge/experience
and some basic JavaScript exposure,
you will be able to dive straight into the example below!

Just ensure that you have
the _latest_
[Elixir](https://elixir-lang.org/install.html#distributions),
[Phoenix](https://hexdocs.pm/phoenix/installation.html)
and
[Postgres](https://github.com/dwyl/learn-postgresql#installation)
installed on your **`localhost`**
before beginning.

```sh
elixir -v
Elixir 1.10.1 (compiled with Erlang/OTP 22)

mix phx.new -v
v1.4.12

psql --version
psql (PostgreSQL) 12.1
```


If you are new to (or rusty on) Elixir/Phoenix,
we _recommend_ reading
[dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir) <br />
and following the
[dwyl/**phoenix-chat-example**](https://github.com/dwyl/phoenix-chat-example)
which is a "_my first phoenix app_".

You don't need to have _any_ knowledge of AWS Lambda,
but if you are curious to learn,
read:
[dwyl/**learn-aws-lambda**](https://github.com/dwyl/learn-aws-lambda)



### 1. Create a Phoenix Project 🆕

In your terminal, create a new Phoenix app using the command:

```sh
mix phx.new app
```

Ensure you install all the dependencies:

```sh
mix deps.get
cd assets && npm install && cd ..
```

Setup the database:

```sh
mix ecto.setup
```

Start the Phoenix server:

```sh
mix phx.server
```

Now you can visit
[`localhost:4000`](http://localhost:4000)
from your web browser.

![phoenix-default-homepage](https://user-images.githubusercontent.com/194400/74361992-c2c4ef80-4dbf-11ea-8112-2dcf6dcf1c51.png)

Also make sure you run the tests to ensure everything works as expected:

```sh
mix test
```

You should see:

```sh
Compiling 16 files (.ex)
Generated app app

17:49:40.111 [info]  Already up
...

Finished in 0.04 seconds
3 tests, 0 failures
```


### 2. Add `ex_aws_lambda` dependency to `deps`

We are using
[`ex_aws_lambda`](https://github.com/ex-aws/ex_aws_lambda)
which depends on
[`ex_aws_lambda`](https://github.com/ex-aws/ex_aws_lambda), <br />
which in turn requires an HTTP library
[`hackney`](https://github.com/benoitc/hackney)
and JSON library
[`poison`](https://github.com/devinus/poison).


Add the following lines to the `deps` list
in the `mix.exs` file:


```elixir
    {:ex_aws, "~> 2.1.0"},
    {:ex_aws_lambda, "~> 2.0"},
    {:hackney, "~> 1.9"},
    {:poison, "~> 3.0"},
```

Then run:

```sh
mix deps.get
```
