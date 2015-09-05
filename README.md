## Slack-Score

An extremely specific slack bot, which connects to fantasy sports Fantrax and displays current
score information in Slack, when you are all "score me"

As I said, extremely specific. But hey, there you go. itch scratched.

### Configuration

Check the .env file. You'll find places for your Slack API key and your fantrax
username and password.

### Running Locally

```
bundle exec ruby slack-score.rb
```

Then, follow instructions over yonder at [dblock/slack-ruby-client](https://github.com/dblock/slack-ruby-client)

### Deploying to Heroku

I'm doing the simplest thing possible: having the Procfile start my slack
client, and paying heroku $7 a month to not shut it down.

### LICENSE

The MIT License (MIT)

Copyright (c) 2015 Jesse Wolgamott

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
