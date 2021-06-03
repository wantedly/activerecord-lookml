RSpec.describe ActiveRecord::LookML::Block do
  describe "#to_lookml" do
    subject { block.to_lookml }
    let(:block) { ActiveRecord::LookML::Block.new(type: type, name: name) }

    context "when block has no field" do
      let(:type) { "view" }
      let(:name) { "some_view_name" }
      let(:lookml) {
        <<~LOOKML
          view: some_view_name {
          }
        LOOKML
      }
      it "retuns expected lookml" do
        expect(subject).to eq lookml
      end
    end

    context "when block has sub blocks as feilds" do
      let(:type) { "view" }
      let(:name) { "some_view_name" }
      let(:lookml) {
        <<~LOOKML
          view: some_view_name {
            dimension: user_id {
            }

            dimension: company_id {
            }
          }
        LOOKML
      }
      it "retuns expected lookml" do
        block << ActiveRecord::LookML::Block.new(type: "dimension", name: "user_id")
        block << ActiveRecord::LookML::Block.new(type: "dimension", name: "company_id")
        expect(subject).to eq lookml
      end
    end

    context "when block has feilds" do
      let(:type) { "dimension_group" }
      let(:name) { "created_at" }
      let(:lookml) {
        <<~LOOKML
          dimension_group: created_at {
            type: time
            sql: ${TABLE}.created_at ;;
          }
        LOOKML
      }
      it "retuns expected lookml" do
        block << ActiveRecord::LookML::Field.new(name: "type", value: "time")
        block << ActiveRecord::LookML::Field.new(name: "sql", value: "${TABLE}.created_at ;;")
        expect(subject).to eq lookml
      end
    end
  end
end
