FROM elixir:1.6.5

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  apt-key add

RUN echo "deb http://security.ubuntu.com/ubuntu xenial-security main" >> /etc/apt/sources.list
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install libssl1.0.0 -y
RUN apt-get install libpq-dev libpq5 -y
RUN apt-get install postgresql-client-10 -y

RUN mix local.hex --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix deps.get
RUN mix local.rebar --force
RUN mix deps.compile
CMD mix test
