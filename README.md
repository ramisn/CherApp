
# Cher.app

### Requirements
 - Ruby v2.6.3
 - Bundler 2.1.4
 - Postgres
 - Node v12.10.0
 - Yarn >= 1.22

### Configuration
```
bundle install
bin/rake db:setup
yarn install
bin/rails server
```

### Configure env variables
 1. Create a file called `.env` based on `.env.sample`
 2. Fill the variables

### Testing
 - Run tests
	 - `rails test`
 - Run system tests
	 - `rails test:system`

### Third party services
 - To learn about the terminology and the services we are using in the app take a look at the `terminology_and_tervices.md` file
