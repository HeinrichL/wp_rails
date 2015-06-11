cd ..
cf push bicycleonrails -c "bundle exec rake db:migrate"
pause