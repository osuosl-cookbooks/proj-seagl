# InSpec test for recipe proj-seagl::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

describe user 'seagl' do
  it { should exist }
  its('home') { should cmp '/home/seagl' }
end

describe file '/etc/sudoers.d/seagl' do
  it { should be_file }
  its('mode') { should cmp 0440 }
  its('owner') { should cmp 'root' }
  its('group') { should cmp 'root' }
  its(:content) { should match(/seagl ALL=\(root\) NOPASSWD:ALL/) }
end

%w(
  nano
  emacs-nox
).each do |pkg|
  describe package pkg do
    it { should be_installed }
  end
end
