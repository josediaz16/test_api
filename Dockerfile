FROM elixir:1.6.5

RUN mix local.hex --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get
CMD mix test
