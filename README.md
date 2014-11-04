# Getting started
- Make sure you have Ruby 2.0.0p451. [rbenv](https://github.com/sstephenson/rbenv) is good for this.
- - I'm not sure why this is necessary, but it was needed to hack this together somehow.
- Run `gem install bundler`.
- Run `bundle install`
- Install [pow](//pow.cx) and optionally install [powder](https://github.com/Rodreegez/powder)
- Symlink this application to work with pow
- Register an application at https://apps.twitter.com/
- Create a new file in this root directory called .env
- Put your Twitter consumer keys and secrets in this file in the syntax below
```
CONSUMER_KEY=xxxxxxxxxxxxxxxxxxxxxxxxx
CONSUMER_SECRET=yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
OAUTH_TOKEN=zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
OAUTH_SECRET=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```
- Your application should now be available at [favpurge.dev](http://favpurge.dev)!
