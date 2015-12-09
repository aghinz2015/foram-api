# class Dummy
#   include ::Filters::RangedFilter

#   ranged_attribute :normal, test_attribute: 'db_attribute'
# end

# describe ::Filters::RangedFilter do
#   subject { Dummy.new }

#   describe 'class methods' do
#     it 'defines self.ranged_attribute' do
#       expect(Dummy).to respond_to :ranged_attribute
#     end

#     context '.ranged_attribute' do
#       it 'adds methods for the requested attribute' do
#         expect(subject).to respond_to :test_attribute_min
#         expect(subject).to respond_to :test_attribute_max
#         expect(subject).to respond_to :test_attribute_min=
#         expect(subject).to respond_to :test_attribute_max=
#       end

#       it 'adds requested attributes to the array of attributes' do
#         expect(Dummy.ranged_attributes).to include([:test_attribute_min, 'db_attribute', '$gte'])
#         expect(Dummy.ranged_attributes).to include([:test_attribute_max, 'db_attribute', '$lte'])
#       end
#     end
#   end

#   describe '#ranged_attributes_scope filter method' do
#     let(:scope) { double(where: true) }

#     context 'when one attribute is set' do
#       it 'calls #where on scope with proper parameters' do
#         expect(scope).to receive(:where).with('db_attribute' => { '$lte' => 0.7 })
#         subject.test_attribute_max = 0.7

#         subject.ranged_attributes_scope(scope)
#       end
#     end

#     context 'when two attributes are set' do
#       it 'calls #where on scope with proper parameters' do
#         expect(scope).to receive(:where).with('db_attribute' => { '$lte' => 0.7, '$gte' => 0.5 })
#         subject.test_attribute_min = 0.5
#         subject.test_attribute_max = 0.7

#         subject.ranged_attributes_scope(scope)
#       end
#     end

#     context 'when attribute is nil' do
#       it 'calls #where on scope with proper parameters' do
#         expect(scope).to receive(:where).with({})

#         subject.ranged_attributes_scope(scope)
#       end
#     end
#   end
# end
