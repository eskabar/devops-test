web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq start -r ./config/boot.rb -C ./config/sidekiq.yml