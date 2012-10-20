require 'spec_helper'

describe SaveGist do
  let(:gist) do
     Gist.new(gist_blobs_attributes: [{blob: "Holla"}])
  end

  let(:save) { SaveGist.new(gist) }

  let(:save_no_write) {
    save.should_receive(:write)
    save
  }

  let(:create) { save_no_write }

  let(:update) {
    gist.stub!(new_record?: false)
    save_no_write
  }

  context "new gist" do
    it "creates Gist" do
      -> { create.() }.
        should change(Gist, :count).by(1)
    end

    it "initializes repo" do
      -> { create.() }.
        should change(gist, :repo).from(nil)

      gist.repo.should be_a(GistRepo)
    end
  end

  context "existing gist" do
    it "updates attributes" do
      -> {
        update.(gist_blobs_attributes: [blob: "hi"])
      }.should change(& -> { gist.gist_blobs.first.blob }).
        from("Holla").to("hi")
    end

    it "doesn't reinitialize repo" do
      gist.should_not_receive(:init_repo)
      update.()
    end
  end


  xit ".write" do
    GistWriter.
      should_receive(:new).
      with(gist).
      and_return(writer = mock(:writer))

    writer.should_receive(:call)

    save.()
  end
end