# The comics test

This is the solution for the comics test provided by Avidity. The task required the development of an HTML page listing the characters from a Marvel story of a specific character using the [Marvel API](http://developer.marvel.com/docs). The character chosen for this solution was [Hawkeye](https://en.wikipedia.org/wiki/Hawkeye_(Clint_Barton)).

## Requirements

Ruby 3.1.2

## Run locally

To get a local copy up and running, follow these steps:

Clone the repo
```shell
git clone https://github.com/pedrofontoura/avidity-test.git
cd avidity-test
```

Install all gems
```shell
bundle install
```

Create a `.env` file in the root folder and set up your Marvel API keys
```shell
PRIVATE_KEY=1234
PUBLIC_KEY=1234
```

Run the application
```shell
bin/dev
```
And now you can visit the site with the URL http://localhost:3000
