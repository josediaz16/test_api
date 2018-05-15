# TestApi

This is a small example of an API built using the following tools and considerations:
  - Docker
  - Elixir
  - Umbrella apps
  - Test driven development with ExUnit
  - RESTFUL concepts

* Dependencies

  This project was built using the following versions:
    - Docker version 17.03.1-ce, build c6d412e
    - docker-compose version 1.11.2, build dfed245

* Configuration

  As initial step run the following command to setup the database:

  `sudo docker-compose run app ./setup_db`

  Run `sudo docker-compose up` to start the web app server.

* GUI Interface

  Visit http://localhost:4000/users/new to create a new user using an HTML form.

* JSON API

  Use any HTTP library to test the API endpoint. Use it with curl like:

  ```
    curl -i -XPOST http://localhost:4000/api/v1/users -H 'Content-Type: application/json' -d '
      {
        "user": {
          "email": "joey@friends.com",
          "name": "Joey",
          "phone_number": "324112233",
          "password": "123456",
          "password_confirmation": "123456",
          "country": "Colombia",
          "city": "Bogota",
          "address": "Calle 10"
        }
      }
    '
  ```

  You would get a response like:

  ```
    HTTP/1.1 201 Created
    server: Cowboy
    date: Tue, 15 May 2018 00:27:13 GMT
    content-length: 135
    content-type: application/json; charset=utf-8
    cache-control: max-age=0, private, must-revalidate
    x-request-id: 2knajjughg05a3ren8000015

    {"phone_number":"324112233","name":"Joey","id":11,"email":"joey@friends.com","country":"Colombia","city":"Bogota","address":"Calle 10"}
  ```

  For now only 'required' and 'confirmation' validations are developed so you will get
  a (400 Bad Request) if you miss the following fields:
    - Email
    - Name
    - Phone Number
    - Password

  Or if Password and Password Confirmation don't match

* Tests

  To run the tests run `sudo docker-compose run app mix test`

* Troubleshooting

  Postgres server data is being mapped to a volume at ./data. If you can't get to run the
  tests or the server due to file permissions do:

    ```
      chown -R `whoami` .data/postgres
    ```
