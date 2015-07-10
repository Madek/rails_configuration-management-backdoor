## Configuration Management Backdoor for Ruby on Rails

This rails engine enables ruby and SQL invocation via HTTP POST requests. It is
meant to be used as a tool for configuration management via local connections.

## Usage

This goes into your `Gemfile`.

    gem 'configuration_management_backdoor', '>= 1.0.0', '< 2.0'

### Example Ruby

    $ curl -u x:YOUR_SECRET_KEY_BASE -X POST  \
        http://localhost:3000/configuration_management_backdoor/invoke \
        -H 'content-type: application/ruby' -d '1 + 1'
    > 2

### Example SQL

    $ curl -u x:YOUR_SECRET_KEY_BASE -X POST \
        http://localhost:3000/configuration_management_backdoor/invoke \
        -H 'content-type: application/sql' -d 'SELECT 1 + 1 AS result'
    > [{"?column?"=>"2"}]

