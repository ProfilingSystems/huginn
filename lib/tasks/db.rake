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
      cmd = "pv -pte #{Rails.root}/db/dump/dump.sql | mysql -u #{user} --password=#{password} -h #{host} #{db}"
    end
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username],
        ActiveRecord::Base.connection_config[:password],
        ActiveRecord::Base.connection_config[:port]
  end

end