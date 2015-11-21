## Configuration Management Backdoor for Ruby on Rails

This rails engine enables ruby and SQL invocation via HTTP POST requests. It is
meant to be used as a tool for configuration management via local connections.

## Usage

This goes into your `Gemfile`.

    gem 'configuration_management_backdoor', '>= 2.1.0', '< 3.0'


## Return values

Results are always returned in JSON format where the value is wrapped under the
`result` key. In case of an evaluation error there will be no result but an
error message and the return status is 422 aka "Unprocessable Entity".


### Examples

#### Ruby

A simple example:

    $ curl -u x:YOUR_SECRET_KEY_BASE  -X POST \
      http://localhost:3000/configuration_management_backdoor/invoke \
      -H 'content-type: application/ruby' -d '1 + 1'

    {"result":2}

This will cause an error in the stack. We also use the `-i` by which curl
will output meta data, too:

    $ curl -i -u x:YOUR_SECRET_KEY_BASE -X POST  \
        http://localhost:3000/configuration_management_backdoor/invoke \
        -H 'content-type: application/ruby' -d '1/0'

    HTTP/1.1 422 Unprocessable Entity
    Content-Type: application/json; charset=utf-8
    ...
    {"error":"divided by 0"}

#### SQL

The structure of the value depends on the adapter. This is for the
native Postgresql adapter:

    $ curl -u x:YOUR_SECRET_KEY_BASE -X POST \
        http://localhost:3000/configuration_management_backdoor/invoke \
        -H 'content-type: application/sql' -d 'SELECT 1 + 1 AS output'

    {"result":[{"output":"2"}]}

Error:

    $ curl -u x:YOUR_SECRET_KEY_BASE -X POST \
        http://localhost:3000/configuration_management_backdoor/invoke \
        -H 'content-type: application/sql' -d 'SELECT 1 / 0'

    {"error":"PG::DivisionByZero: ERROR:  division by zero\n: SELECT 1 / 0"}

