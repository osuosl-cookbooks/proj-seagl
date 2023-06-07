control 'default' do
  describe user 'seagl' do
    it { should exist }
    its('home') { should cmp '/home/seagl' }
  end

  describe command('sudo -U seagl -l') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /\(root\) NOPASSWD: ALL/ }
  end

  %w(
    emacs-nox
    nano
  ).each do |pkg|
    describe package pkg do
      it { should be_installed }
    end
  end
end
