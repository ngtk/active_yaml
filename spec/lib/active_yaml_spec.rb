require 'spec_helper'

describe ActiveYaml::ClassMethods do
  before do
    class Book
      include ActiveYaml
      attr_accessor :author, :title
      @store = YAML::Store.new("spec/files/book.yml")
    end
  end

  describe '.store' do
    subject { Book.store }
    it { is_expected.to be_a(YAML::Store) }
  end

  describe '.add' do
    subject { Book.add(record) }
    let(:record) { Book.new }

    context 'store.roots.max is nil' do
      include_context :use_tempfile

      before do
        filename = tempfile.path
        Book.class_eval do
          @store = YAML::Store.new(filename)
        end
      end

      it 'adds record(id: 1)' do
        expect { subject }.to change { Book.count }.by(1)
        expect(record.id).to eq 1
      end
    end

    context 'store.root.max is 2' do
      let(:yaml_file) { File.new('spec/files/2_records.yml') }
      include_context :use_tempfile

      before do
        filename = tempfile.path
        Book.class_eval do
          @store = YAML::Store.new(filename)
        end
      end

      it 'adds record(id: 3)' do
        expect { subject }.to change { Book.count }.by(1)
        expect(record.id).to eq 3
      end
    end
  end

  describe '.update' do
    subject { Book.update(record) }

    let(:record) { Book.first }
    let(:yaml_file) { File.new('spec/files/book.yml') }
    include_context :use_tempfile
    before do
      filename = tempfile.path
      Book.class_eval do
        @store = YAML::Store.new(filename)
      end
      record.title = "Apple"
    end

    it 'update record' do
      expect { subject }.to change { Book.first.title }.to("Apple")
    end
  end

  describe '.destroy' do
    subject { Book.destroy(id) }

    let(:id) { 1 }
    let(:yaml_file) { File.new('spec/files/book.yml') }
    include_context :use_tempfile
    before do
      filename = tempfile.path
      Book.class_eval do
        @store = YAML::Store.new(filename)
      end
    end

    it 'destroy a record' do
      expect { subject }.to change { Book.count }.by(-1)
    end
  end

  describe '.first' do
    subject { Book.first }

    before do
      Book.class_eval do
        @store = YAML::Store.new('spec/files/first.yml')
      end
    end

    it 'returns minimam id record' do
      expect(subject.id).to eq 3
    end
  end

  describe '.last' do
    subject { Book.last }

    before do
      Book.class_eval do
        @store = YAML::Store.new('spec/files/last.yml')
      end
    end

    it 'returns maximum id record' do
      is_expected.to be_a(Book)
      expect(subject.id).to eq 15
    end
  end

  describe '.all' do
    subject { Book.all }

    before do
      Book.class_eval do
        @store = YAML::Store.new('spec/files/book.yml')
      end
    end

    it 'returns all records' do
      is_expected.to all be_a(Book)
      expect(subject.count).to eq 3
    end
  end

  describe '.count' do
    subject { Book.count }

    before do
      Book.class_eval do
        @store = YAML::Store.new('spec/files/book.yml')
      end
    end

    it 'returns all record count' do
      is_expected.to eq 3
    end
  end

  describe '.any?' do
    subject { Book.any? }

    context 'blank' do
      include_context :use_tempfile
      before do
        filename = tempfile.path
        Book.class_eval do
          @store = YAML::Store.new(filename)
        end
      end

      it { is_expected.to be_falsy }
    end

    context 'present' do
      before do
        Book.class_eval do
          @store = YAML::Store.new('spec/files/book.yml')
        end
      end

      it { is_expected.to be_truthy }
    end
  end

  describe '.empty?' do
    subject { Book.empty? }

    context 'blank' do
      include_context :use_tempfile
      before do
        filename = tempfile.path
        Book.class_eval do
          @store = YAML::Store.new(filename)
        end
      end

      it { is_expected.to be_truthy }
    end

    context 'present' do
      before do
        Book.class_eval do
          @store = YAML::Store.new('spec/files/book.yml')
        end
      end

      it { is_expected.to be_falsy }
    end
  end
end
