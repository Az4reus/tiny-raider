require 'rake'

task default: :run

task :run do
  credentials = `cat credentials.secret`
  exec("bundle exec ruby src/bot.rb #{credentials}")
end

task :deploy do
  sh 'ssh `cat deployment-target` /home/az/tiny-raider/redeploy.sh'
end

task :docker do
  sh 'docker build .  -t az/tiny-raider'
end
