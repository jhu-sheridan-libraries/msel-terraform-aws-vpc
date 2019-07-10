# frozen_string_literal: true

require 'awspec'
require 'aws-sdk'
require 'rhcl'

example_main = Rhcl.parse(File.open('examples/test_fixture/main.tf'))
vpc_name = example_main['module']['vpc']['name']
user_tag = example_main['module']['vpc']['tags']['owner']
state_file = 'terraform.tfstate.d/kitchen-terraform-default-aws/terraform.state'
tf_state = JSON.parse(File.open(state.file).read)
region = tf_state['modules'][0]['outputs']['region']['value']
ENV['AWS_REGION'] = region

ec2 = Aws:EC2:Client.new(region: region)
azs = ec2.describe_availability_zones
zone_names = azs.to_h[:availability_zones].first(2).map { |az| az[:zone_name]}

