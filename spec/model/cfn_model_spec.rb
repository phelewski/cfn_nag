require 'spec_helper'
require 'cfn_model'


describe CfnModel do
  context 'when resource template creates single resource - with no security groups' do
    before(:all) do
      template_name = 'just_dhcp_options.json'
      @cfn_model = CfnModel.new(File.join(__dir__, 'test_templates', template_name))
    end

    it 'returns no security groups' do
      expect(@cfn_model.security_groups).to eq []
    end
  end

  context 'when resource template creates single security group with no ingress rules' do
    before(:all) do
      template_name = 'single_security_group_empty_ingress.json'
      @cfn_model = CfnModel.new(File.join(__dir__, 'test_templates', template_name))
    end

    it 'returns 1 security group' do
      expect(@cfn_model.security_groups.size).to eq 1
    end

    it 'returns a security group with no ingress rules' do
      actual_security_group = @cfn_model.security_groups.first

      expect(actual_security_group.ingress_rules.size).to eq 0
    end
  end

  context 'when resource template creates single security group with one inline ingress from cidr' do
    before(:all) do
      template_name = 'single_security_group_one_cidr_ingress.json'
      @cfn_model = CfnModel.new(File.join(__dir__, 'test_templates', template_name))
    end

    it 'returns 1 security group' do
      expect(@cfn_model.security_groups.size).to eq 1
    end

    it 'returns a security group with 1 ingress from 10.1.2.3/32' do
      actual_security_group = @cfn_model.security_groups.first

      expect(actual_security_group.ingress_rules.size).to eq 1

      expect(actual_security_group.ingress_rules.first['CidrIp']).to eq '10.1.2.3/32'

      expect(actual_security_group.vpc_id).to eq 'vpc-9f8e9dfa'
      expect(actual_security_group.group_description).to eq 'some_group_desc'
    end
  end

  context 'when resource template creates two security groups with one,two inline ingress from cidr' do
    before(:all) do
      template_name = 'two_security_group_two_cidr_ingress.json'
      @cfn_model = CfnModel.new(File.join(__dir__, 'test_templates', template_name))
    end

    it 'returns 2 security groups' do
      expect(@cfn_model.security_groups.size).to eq 2
    end

    it 'returns two security group with 1 ingress from 10.1.2.3/32' do
      first_actual_security_group = @cfn_model.security_groups.first

      expect(first_actual_security_group.ingress_rules.size).to eq 1
      expect(first_actual_security_group.ingress_rules.first['CidrIp']).to eq '10.1.2.3/32'

      second_actual_security_group = @cfn_model.security_groups[1]

      expect(second_actual_security_group.ingress_rules.size).to eq 2
      expect(second_actual_security_group.ingress_rules.first['CidrIp']).to eq '0.0.0.0/0'
      expect(second_actual_security_group.ingress_rules[1]['CidrIp']).to eq '1.2.3.4/32'
    end
  end

  context 'when resource template creates two security groups with one,two externalized ingress from cidr' do
    before(:all) do
      template_name = 'two_security_group_two_externalized_cidr_ingress.json'
      @cfn_model = CfnModel.new(File.join(__dir__, 'test_templates', template_name))
    end

    it 'returns 2 security groups' do
      expect(@cfn_model.security_groups.size).to eq 2
    end

    it 'returns two security group with 1 ingress from 10.1.2.3/32' do
      first_actual_security_group = @cfn_model.security_groups.first

      expect(first_actual_security_group.ingress_rules.size).to eq 1
      expect(first_actual_security_group.ingress_rules.first['CidrIp']).to eq '10.1.2.3/32'

      second_actual_security_group = @cfn_model.security_groups[1]

      expect(second_actual_security_group.ingress_rules.size).to eq 2
      expect(second_actual_security_group.ingress_rules.first['CidrIp']).to eq '0.0.0.0/0'
      expect(second_actual_security_group.ingress_rules[1]['CidrIp']).to eq '1.2.3.4/32'
    end
  end
end