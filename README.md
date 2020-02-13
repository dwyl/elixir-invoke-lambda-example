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

To keep our `Elixir`/`Phoenix` App
as _focussed_ as possible,
we are ***delegating*** all
of the **_non-core_ functionality**
to **AWS Lambda** functions.
AWS Lambda allows us
to offload specific non-core functionality
such as sending/receiving emails and
uploading/resizing/transcoding images/video.
This non-core functionality
still needs to work _flawlessly_
but it will not be invoked directly by end-users.
Rather the Lambda functions
will be invoked _asynchronously_
by `Elixir`
with as little overhead as possible.

If **keeping** your **app _focussed_**
on it's **core business logic**
sounds like a **_good_ idea** to you, <br />
follow along with us on the
**`Elixir` invoke `Lambda` _quest_**! 🏔️


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
v1.4.13

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
read our beginner's guide:
[dwyl/**learn-aws-lambda**](https://github.com/dwyl/learn-aws-lambda)


#### Ensure you have `aws-ses-lambda` running!

This example invokes our
[**`aws-ses-lambda`**](https://github.com/dwyl/aws-ses-lambda),
which as it's name suggests is a AWS Lambda function
that handles sending email
using AWS Simple Email Service (SES).
The setup and deployment instructions
are all included in
[https://github.com/dwyl/aws-ses-lambda**#how**](https://github.com/dwyl/aws-ses-lambda#how-)

You need to _deploy_ the Lambda function
and _test_ it in the AWS console
ensuring that it's working _before_
attempting to invoke it from `Elixir`.

With that done, let's get back to our quest!


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

Having established that your Phoenix App works as expected,
let's dive into the fun part!


### 2. Add `ex_aws_lambda` to `deps` 🎁

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
e.g:
[mix.exs#L47-L52](https://github.com/dwyl/elixir-invoke-lambda-example/blob/b8a226a86f465781acc0d87d7e777bb637f605a8/mix.exs#L47-L52)

Then run:

```sh
mix deps.get
```

### 3. Environment Variables 🔐

In order to _invoke_ a AWS Lambda function
(_and **specifically** our **`aws-ses-lambda`**_),
we need a handful of Environment Variables to be defined.

To speed this up, we created an
[`.env_sample`](https://github.com/dwyl/elixir-invoke-lambda-example/blob/master/.env_sample)
file that has all the Environment Variables you need:

```
export AWS_REGION=eu-west-1
export AWS_ACCESS_KEY_ID=YOURACCESSKEYID
export AWS_SECRET_ACCESS_KEY=SUPERSECRETACCESSKEY
export SENDER_EMAIL_ADDRESS=your.ses.verified@email.com
export RECIPIENT_EMAIL="yourname+elixir.invoke@gmail.com"
```

Copy this file into a _new_ file called `.env`.
e.g:

```sh
cp .env_sample .env && echo ".env\n" > .gitignore
```

Then update the values to your _real_ ones!

Finally run `source .env` in your terminal.
Confirm that the environment variables are loaded by
running the **`printenv`** commnad.


> Note: If you are new to Environment Variables,
see: https://github.com/dwyl/learn-environment-variables


### 4. Write a Test! 🔴😮

Yes, even in these simple examples,
we can still follow Test Driven Development
([TDD](https://github.com/dwyl/learn-tdd)),
in fact it's a _really_ good idea
to _always_ write tests!
This way you _know_ the Lambda invocation
works _exactly_ the way you expect it to!

Create a _new_ file called
`test/app_web/controllers/invoke_lambda_test.exs`






> **Side note**:
I did't get much out of reading the
[Docs](https://hexdocs.pm/ex_aws/ExAws.html)
for [`ex_aws`](https://github.com/ex-aws/ex_aws)
so I ended up reading the _tests_
in order to undestand how the package works:
[/test/ex_aws/auth_test.exs](https://github.com/ex-aws/ex_aws/blob/ecd51b1965909119ee597d6c0783334e30e59e58/test/ex_aws/auth_test.exs)
Don't bother reading the tests for
[`ex_aws_lambda`](https://github.com/ex-aws/ex_aws_lambda)
they
[aren't very good](https://github.com/dwyl/aws-ses-lambda/issues/8#issuecomment-585360225)
... <br />
Moral of the story:
**_always_ write good tests** for your code.
Other people will read them
and ~~_totally_ judge you as a developer~~
learn how you implement things. 😜





### 5. Write the `invoke` Function to Make the Test _Pass_! ✅




#### 5.1 Invoke in `iex`

In your terminal, open `iex`:

```
iex -S mix
```

Then _invoke_ the Lambda by typing
`AppWeb.PageController.invoke`:

```elixir
iex(1)> AppWeb.PageController.invoke
{:ok,
 %{
   "MessageId" => "010201703dd218c7-ae82fd07-9c08-4215-a4a9-4b723b98d8f3-000000",
   "ResponseMetadata" => %{
     "RequestId" => "def1b013-331e-4d10-848e-6f0dbd709434"
   }
 }}
```

<br /><br />

### Trouble Shooting 🤷‍

If you forget to include some data
you will get a friendly error message. <br />
e.g: In this case I didn't have
the `RECIPIENT_EMAIL_ADDRESS` environment variable defined <br />
so there was no "**To**" (_email address_) defined in the `event`:

```elixir
{:ok,
 %{
   "errorMessage" => "Missing required header 'To'.",
   "errorType" => "InvalidParameterValue",
   "trace" => ["InvalidParameterValue: Missing required header 'To'.",
    "    at Request.extractError (/var/task/node_modules/aws-sdk/lib/protocol/query.js:50:29)",
    "    at Request.callListeners (/var/task/node_modules/aws-sdk/lib/sequential_executor.js:106:20)",
    "    at Request.emit (/var/task/node_modules/aws-sdk/lib/sequential_executor.js:78:10)",
    "    at Request.emit (/var/task/node_modules/aws-sdk/lib/request.js:683:14)",
    "    at Request.transition (/var/task/node_modules/aws-sdk/lib/request.js:22:10)",
    "    at AcceptorStateMachine.runTo (/var/task/node_modules/aws-sdk/lib/state_machine.js:14:12)",
    "    at /var/task/node_modules/aws-sdk/lib/state_machine.js:26:10",
    "    at Request.<anonymous> (/var/task/node_modules/aws-sdk/lib/request.js:38:9)",
    "    at Request.<anonymous> (/var/task/node_modules/aws-sdk/lib/request.js:685:12)",
    "    at Request.callListeners (/var/task/node_modules/aws-sdk/lib/sequential_executor.js:116:18)"]
 }}
```
> **Note**: _Obviously_ we don't _like_ the fact
that the **`ex_aws`** package returned an
`{:ok, %{"errorMessage" => "Missing required header 'To'."}` ...
an **`:error`** should not be "**`:ok`**" ... 🙄
but let's not get hung up on it.

When we _did_ correctly set
the `RECIPIENT_EMAIL_ADDRESS` environment variable, <br />
we got the following success message confirming the email was sent:
```elixir
{:ok,
 %{
   "MessageId" => "010201703dd218c7-ae82fd07-9c08-4215-a4a9-4b723b98d8f3-000000",
   "ResponseMetadata" => %{
     "RequestId" => "def1b013-331e-4d10-848e-6f0dbd709434"
   }
 }}
```


<br /> <br />
`TODO:` open an issue on https://github.com/ex-aws/ex_aws_lambda/issues
sharing a link to this repo for anyone considering using the package!
