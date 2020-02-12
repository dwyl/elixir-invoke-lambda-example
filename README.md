# Elixir Invoke Lambda Example λ

A basic example showing how to invoke AWS Lambda functions
from Elixir/Phoenix Apps.

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
the latest Elixir and Phoenix
installed on your `localhost`
before beginning.

If you are new to (or rusty on) Elixir/Phoenix,
we _recommend_ reading
[dwyl/**learn-elixir**](https://github.com/dwyl/learn-elixir)
and following the
[dwyl/**phoenix-chat-example**](https://github.com/dwyl/phoenix-chat-example)
which is a "_my first phoenix app_".

You don't need to have _any_ knowledge of AWS Lambda,
but if you are curious to learn,
see:
[dwyl/**learn-aws-lambda**](https://github.com/dwyl/learn-aws-lambda)

<br />

### 1. Create a Phoenix Project 🆕
