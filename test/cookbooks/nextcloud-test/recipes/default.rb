dbcreds = data_bag_item('proj-seagl', 'dbcredentials')
servercreds = data_bag_item('proj-seagl', 'servercredentials')
nextcloudcreds = data_bag_item('proj-seagl', 'nextcloudcredentials')

osl_mysql_test 'foobar' do
  username dbcreds['db_user']
  password dbcreds['db_passw']
end
osl_nextcloud 'cloud.seagl.org' do
  database_host dbcreds['db_host']
  database_name dbcreds['db_dbname']
  database_password dbcreds['db_passw']
  database_user dbcreds['db_user']
  nextcloud_admin_password nextcloudcreds['admin_pass']
  nextcloud_admin_user nextcloudcreds['admin_user']
  server_aliases %w(localhost cloud.seagl.org)
  version '23'
  sensitive false
end
