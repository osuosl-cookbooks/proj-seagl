# InSpec test for recipe proj-seagl::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe user 'seagl' do
  it { should exist }
  its('home') { should cmp '/home/seagl' }
end

describe command('sudo -u seagl sudo -l') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /\(root\) NOPASSWD: ALL/ }
end

%w(
  nano
  emacs-nox
).each do |pkg|
  describe package pkg do
    it { should be_installed }
  end
end
