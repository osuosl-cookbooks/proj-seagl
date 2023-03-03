# InSpec test for recipe proj-seagl::nextcloud

control 'osl_nextcloud' do
  describe file('/etc/php.ini') do
    [
      /^memory_limit=512M$/,
      /^post_max_size=65M$/,
      /^upload_max_filesize=60M$/,
      /^output_buffering=false$/,
    ].each do |conf|
      its('content') { should match(conf) }
    end
  end

  describe package 'nextcloud' do
    it { should be_installed }
  end

  describe package 'redis' do
    it { should be_installed }
  end

  describe service 'redis' do
    it { should be_running }
  end

  describe service 'httpd' do
    it { should be_enabled }
    it { should be_running }
  end

  describe directory '/usr/share/nextcloud/data' do
    it { should exist }
    its('owner') { should eq 'apache' }
    its('group') { should eq 'apache' }
  end

  describe host('localhost') do
    it { should be_reachable }
    it { should be_resolvable }
  end

  describe command('sudo -u apache php /usr/share/nextcloud/occ status') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /installed: true/ }
    its('stdout') { should match /versionstring: 23.0.7/ }
  end

  describe command('sudo -u apache php /usr/share/nextcloud/occ config:system:get installed') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^true$/ }
  end

  describe command('sudo -u apache php /usr/share/nextcloud/occ config:system:get redis') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^host: 127.0.0.1$/ }
    its('stdout') { should match /^port: 6379$/ }
  end

  describe http('http://localhost') do
    its('status') { should eq 200 }
    its('headers.Content-Type') { should match 'text/html' }
  end

  describe http('http://localhost', headers: { 'host' => 'cloud.seagl.org' }) do
    its('status') { should eq 200 }
    its('headers.Content-Type') { should match 'text/html' }
  end
end
