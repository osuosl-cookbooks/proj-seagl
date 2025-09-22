control 'default' do
  describe user 'seagl' do
    it { should exist }
    its('home') { should cmp '/home/seagl' }
  end

  describe command('sudo -U seagl -l') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /\(root\) NOPASSWD: ALL/ }
  end

  packages = if os.name == 'almalinux' && os.release.to_i <= 9
    %w(emacs-nox nano)
  else
    %w(emacs-nw nano)
  end

  packages.each do |pkg|
    describe package pkg do
      it { should be_installed }
    end
  end
end
