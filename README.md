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

#### Create an app on Slack.

 [Press Build your own app](https://api.slack.com) 

#### Setup a bot and retrive your SLACK_CLIENT_ID and SLACK_CLIENT_SECRET

![Retrive these fields](https://image.ibb.co/dmASCK/app_setup.png)

#### Find out your team id to make it a support team 

[Go to this link](https://api.slack.com/methods/team.info/test)

_Choose your workspace and press Test Method and then you can get your team id from the response_

![Generate a tocken if you don't already have it](https://image.ibb.co/i4mTKz/Deepin_Screenshot_select_area_20180918155451.png)

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


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kubot.
