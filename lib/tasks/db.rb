namespace :db do

  desc "Dumps the database to db/dump/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user, password, port|
      cmd = "mysqldump  -P #{port} -h #{host} -u #{user} --password=#{password} #{db} > #{Rails.root}/db/dump/dump.sql"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    with_config do |app, host, db, user, password, port|
      cmd = "mysql -P #{port} -h #{host} -u #{user} --password=#{password} #{db} < #{Rails.root}/db/dump/dump.sql"
    end
    puts cmd
    exec cmd
  end

end