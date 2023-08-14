web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -C config/sidekiq.yml
log: tail -f log/development.log
release: bundle exec rake db:migrate
clock: bundle exec clockwork app/jobs/clockwork.rb
