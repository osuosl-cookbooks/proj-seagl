control 'nextcloud' do
  describe http('http://localhost') do
    its('status') { should eq 200 }
    its('headers.Content-Type') { should match 'text/html' }
  end

  describe http('http://localhost', headers: { 'host' => 'cloud.seagl.org' }) do
    its('status') { should eq 302 }
    its('headers.Content-Type') { should match 'text/html' }
    its('headers.Location') { should match 'http://cloud.seagl.org/index.php/login' }
  end

  describe command('sudo -u apache php /var/www/cloud.seagl.org/nextcloud/occ status') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /installed: true/ }
    its('stdout') { should match /versionstring: 30/ }
  end

  describe command('sudo -u apache php /var/www/cloud.seagl.org/nextcloud/occ check') do
    its('exit_status') { should eq 0 }
  end

  describe command('sudo -u apache php /var/www/cloud.seagl.org/nextcloud/occ config:system:get trusted_domains') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^cloud.seagl.org$/ }
    its('stdout') { should match /^localhost$/ }
  end

  describe command('sudo -u apache php /var/www/cloud.seagl.org/nextcloud/occ config:system:get mail_domain') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /^cloud.seagl.org$/ }
  end
end
