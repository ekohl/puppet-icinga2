require 'spec_helper'

describe('icinga2::feature', :type => :define) do
  let(:title) { 'bar' }
  let(:pre_condition) do
    [
      "class { 'icinga2': features => [], }",
      # config file will be created by any feature class
      "icinga2::object { 'icinga2::feature::foo':
        object_name => 'foo',
        object_type => 'FooComponent',
        target      => '/etc/icinga2/features-available/foo.conf',
        order       => '10',
      }"
    ]
  end

	before(:each) do
		# Fake assert_private function from stdlib to not fail within this test
		Puppet::Parser::Functions.newfunction(:assert_private, :type => :rvalue) { |args|
		}
	end

  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    context "#{os} with ensure => foo (not a valid value)" do
      let(:params) { {:ensure => 'foo'} }

      it do
        expect {
          should contain_icinga2__feature('foo')
        }.to raise_error(Puppet::Error, /expects a match for Enum\['absent', 'present'\]/)
      end
    end


    context "#{os} with ensure => present, feature => foo" do
      let(:params) { {:ensure => 'present', :feature => 'foo'} }

      it {
        should contain_file('/etc/icinga2/features-enabled/foo.conf').with({
          'ensure' => 'link',
        }).that_notifies('Class[icinga2::service]')
      }
    end


    context "#{os} with ensure => absent, feature => foo" do
      let(:params) { {:ensure => 'absent', :feature => 'foo'} }

      it {
        should contain_file('/etc/icinga2/features-enabled/foo.conf').with({
          'ensure' => 'absent',
        }).that_notifies('Class[icinga2::service]')
      }
    end
  end
end