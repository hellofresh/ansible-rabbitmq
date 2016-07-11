require_relative 'helper_spec.rb'

describe user('rabbitmq') do
  it { should exist }
end

describe group('rabbitmq') do
  it { should exist }
end

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/lib/rabbitmq/mnesia') do
  it { should be_directory }
  it { should be_mode 750 }
  it { should be_owned_by 'rabbitmq' }
  it { should be_grouped_into 'rabbitmq' }
end

describe "rabbitmq should be listenning to the unencrypted port" do
   describe port(25672) do
        it { should be_listening.with('tcp') }
   end
end

describe "rabbitmq should be not listenning to the SSL port" do
   describe port(5671) do
        it { should_not be_listening.with('tcp') }
   end
end

describe command('sudo rabbitmqctl status') do
  its(:exit_status) { should eq 0 }
end

describe file('/etc/rabbitmq/rabbitmq-env.conf') do
  it { should be_mode 640 }
  it { should be_file }
  it { should be_owned_by 'rabbitmq' }
  it { should be_grouped_into 'rabbitmq' }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_mode 640 }
  it { should be_file }
  it { should be_owned_by 'rabbitmq' }
  it { should be_grouped_into 'rabbitmq' }
end