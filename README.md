# Kubot

Kubot is a Slack support bot that uses Slack API to foward messages from workspaces that are given support to workspace that provides it. It creates a database where all the workspaces registered are stored. And once Kubot is asked a question on channel in a supported workspace a corresponding channel will be created in support workspace and all the messages will be forwarded between this two channels. It's a helpful tool to manage your support workflow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kubot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kubot

## Usage

Create an app on Slack.

Setup a bot there and retrive your SLACK_CLIENT_ID and SLACK_CLIENT_SECRET, you also need to know you team id 

export SLACK_CLIENT_ID, SLACK_CLIENT_SECRET and SLACK_SUPPORT_TEAM
```
export SLACK_CLIENT_ID='...'
export SLACK_CLIENT_SECRET='...'
export SLACK_SUPPORT_TEAM='...'
```

Run kubot
```
kubot start
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kubot.
