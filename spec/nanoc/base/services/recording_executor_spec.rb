describe Nanoc::Int::RecordingExecutor do
  let(:executor) { described_class.new }

  let(:rep) { double(:rep) }

  describe '#filter' do
    it 'records filter call without arguments' do
      executor.filter(rep, :erb)
      expect(executor.rule_memory).to include([:filter, :erb, {}])
    end

    it 'records filter call with arguments' do
      executor.filter(rep, :erb, x: 123)
      expect(executor.rule_memory).to include([:filter, :erb, { x: 123 }])
    end
  end

  describe '#layout' do
    it 'records layout call without arguments' do
      executor.layout(rep, '/default.*')
      expect(executor.rule_memory).to include([:layout, '/default.*'])
    end

    it 'records layout call with arguments' do
      executor.layout(rep, '/default.*', x: 123)
      expect(executor.rule_memory).to include([:layout, '/default.*', { x: 123 }])
    end
  end

  describe '#snapshot' do
    context 'snapshot already exists' do
      before do
        executor.snapshot(rep, :foo, stuff: :giraffe)
      end

      it 'raises when creating same snapshot' do
        expect { executor.snapshot(rep, :foo, stuff: :donkey) }
          .to raise_error(Nanoc::Int::Errors::CannotCreateMultipleSnapshotsWithSameName)
      end
    end

    it 'records snapshot call without arguments' do
      executor.snapshot(rep, :foo)
      expect(executor.rule_memory).to include([:snapshot, :foo, {}])
    end

    it 'records snapshot call with arguments' do
      executor.snapshot(rep, :foo, x: 123)
      expect(executor.rule_memory).to include([:snapshot, :foo, { x: 123 }])
    end

    it 'can create multiple snapshots with different names' do
      executor.snapshot(rep, :foo)
      executor.snapshot(rep, :bar)

      expect(executor.rule_memory).to include([:snapshot, :foo, {}])
      expect(executor.rule_memory).to include([:snapshot, :bar, {}])
    end
  end

  describe '#record_write' do
    it 'records write call' do
      executor.record_write(rep, '/about.html')
      expect(executor.rule_memory).to include([:write, '/about.html'])
    end
  end
end
