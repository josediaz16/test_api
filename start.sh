#!/bin/bash

until $(curl --output /dev/null --silent --head --fail http://rabbitmq:15672); do
  echo -e 'Waiting for rabbitmq\n'
  sleep 1
done

until $(psql -h "postgres" -U "postgres" -w "postgres" -c '\q'); do
  echo -e "Waiting for postgres\n"
done

$@
