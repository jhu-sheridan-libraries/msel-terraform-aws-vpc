# frozen_string_literal: true

require 'awspec'
require 'aws-sdk'
require 'rhcl'

terraform_state_name = "-kitchen-terraform-default-aws"
example_main = Rhcl.parse(File.open('test/test_fixture/main.tf'))
environment_tag = terraform_state_name[1..-1]
vpc_name = example_main['module']['vpc']['project_name'] + terraform_state_name
gateway_name = example_main['module']['vpc']['project_name'] + terraform_state_name + "-public"
cidr = example_main['module']['vpc']['cidr_block']
owner_name = example_main['module']['vpc']['tags']['Owner']

describe vpc(vpc_name.to_s) do
    it { should exist }
    it { should be_available }
    it { should have_tag('Name').value(vpc_name.to_s)}
    it { should have_tag('Environment').value(environment_tag.to_s)}
    it { should have_tag('Owner').value(owner_name.to_s)}
    it { should have_vpc_attribute('enableDnsHostnames')}
    it { should have_vpc_attribute('enableDnsSupport')}
end

describe internet_gateway(gateway_name) do
    it { should exist }
    it { should be_attached_to(vpc_name)}
    it { should have_tag('Name').value(gateway_name)}
    it { should have_tag('Environment').value(environment_tag)}
end