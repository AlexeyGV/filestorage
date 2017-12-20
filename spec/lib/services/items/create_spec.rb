require 'rails_helper'

describe Services::Items::Create do
  let(:file) { fixture_file_upload('items/file_to_upload.txt') }
  let(:service) { described_class.new(file) }

  describe '#call' do
    let(:new_item) { double(:new_item) }
    subject { service.call }

    before do
      service.instance_variable_set(:@item, new_item)
    end

    it 'should use transaction' do
      expect(Item).to receive(:transaction)
      subject
    end

    context 'when save passed' do
      before do
        allow(new_item).to receive(:path=)
        allow(new_item).to receive(:original_filename=)
        allow(new_item).to receive(:save!)
        # REVIEW: figure a better way to declare this
        # allow(new_item).to receive_messages(:path=, :original_filename=, :save!)
        allow(service).to receive(:save_file)
      end

      it 'should return something' do
        expect(subject).to be_truthy
        subject
      end

      it 'should save item' do
        expect(new_item).to receive(:save!)
        subject
      end

      it 'should save file' do
        expect(service).to receive(:save_file)
        subject
      end
    end

    context 'when save failed' do
      before do
        allow(new_item).to receive(:path=)
        allow(new_item).to receive(:original_filename=)
        allow(new_item).to receive(:save!).and_raise ActiveRecord::RecordInvalid
        allow(service).to receive(:remove_file)
      end

      it 'should return false' do
        expect(subject).to be_falsey
      end

      it 'should NOT save item' do
        expect(new_item).not_to receive(:save!)
      end

      it 'should remove file' do
        expect(service).to receive(:remove_file)
        subject
      end
    end
  end

  describe '#remove_file' do
    subject { service.send(:remove_file) }

    context 'file is absent' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'should not remove file' do
        expect(File).not_to receive(:delete)
      end
    end

    context 'file persists' do
      before do
        allow(File).to receive(:exist?).and_return(true)
        # allow(File).to receive(:delete).and_return(true)
      end

      # TODO: File has to receive :delete.
      # It should and it raises exception cause file is missing
    end
  end

  describe '#filename' do
    let(:random_filename) { 'random_filename' }
    let(:value) do
      random_filename << File.extname(file.original_filename)
    end
    subject { service.send(:filename) }

    before do
      allow(service).to receive(:digest).and_return(random_filename)
    end

    it { is_expected.to eq value }
  end

  describe '#file_basename' do
    let(:timestamp) { service.send(:timestamp) }
    let(:value) do
      File.basename(file.original_filename) << timestamp
    end

    subject { service.send(:file_basename) }

    it { is_expected.to eq value }
  end

  describe '#timestamp' do
    subject { service.send(:timestamp) }

    it 'should return timestamp' do
      expect(Time).to receive_message_chain(:zone, :now, :strftime)
      subject
    end
  end

  describe '#digest' do
    let(:filename) { 'random_string.txt' }
    subject { service.send(:digest, filename) }

    it 'should use MD5 for encoding' do
      expect(Digest::MD5).to receive(:hexdigest).with(filename)
      subject
    end
  end
end
