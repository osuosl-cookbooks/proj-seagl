secrets = data_bag_item('proj-seagl', 'nextcloud')

osl_mysql_test secrets['db']['name'] do
  username secrets['db']['user']
  password secrets['db']['passwd']
end
