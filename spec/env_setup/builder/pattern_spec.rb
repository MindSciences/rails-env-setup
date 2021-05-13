require 'spec_helper'
require 'env_setup/builder/pattern'

RSpec.describe EnvSetup::Builder::Pattern do
  let(:builder) { described_class.new(value, params) }

  context 'with one replacement' do
    let(:params) { { 'MY_VAR' => 'Hey!' } }
    let(:value) { { 'pattern' => 'somethig{{MY_VAR}}' } }

    it 'generates var with embbeded params' do
      expect(builder.call).to eq 'somethigHey!'
    end
  end

  context 'with multiple replacements' do
    let(:params) { { 'MY_VAR' => 'Hey!', 'FOO' => 'bar' } }
    let(:value) { { 'pattern' => 'somethig{{MY_VAR}}.{{FOO}}' } }

    it 'generates var with embbeded params' do
      expect(builder.call).to eq 'somethigHey!.bar'
    end
  end
end
