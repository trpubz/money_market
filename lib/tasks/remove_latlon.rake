namespace :db do
  desc "remove lat lon from db::market table"
  task remove_ll: :environment do
    ActiveRecord::Base.connection.execute <<-SQL
      ALTER TABLE markets DROP COLUMN IF EXISTS lat;
      ALTER TABLE markets DROP COLUMN IF EXISTS lon;
    SQL

    puts "Columns lat and lon removed from markets table."
  end
end
