class Dummy
  include ::Filters::BooleanFilter

  boolean_attribute is_test_attribute: 'db_attribute'
end

describe ::Filters::BooleanFilter do
  subject { Dummy.new }

  describe 'class methods' do
    it 'defines self.boolean_attribute' do
      expect(Dummy).to respond_to :boolean_attribute
    end

    context '.boolean_attribute' do
      it 'adds methods for the requested attribute' do
        expect(subject).to respond_to :is_test_attribute
        expect(subject).to respond_to :is_test_attribute=
      end

      it 'adds requested attribute to the array of boolean attributes' do
        expect(Dummy.boolean_attributes).to include([:is_test_attribute, 'db_attribute'])
      end
    end
  end

  describe '#boolean_attributes_scope filter method' do
    let(:scope) { double(where: true) }

    context 'when attribute is set' do
      it 'calls #where on scope with proper parameters' do
        expect(scope).to receive(:where).with('db_attribute' => true)
        subject.is_test_attribute = true

        subject.boolean_attributes_scope(scope)
      end
    end

    context 'when attribute is nil' do
      it 'calls #where on scope with proper parameters' do
        expect(scope).to receive(:where).with({})
        subject.is_test_attribute = nil

        subject.boolean_attributes_scope(scope)
      end
    end
  end
end
