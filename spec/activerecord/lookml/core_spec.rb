RSpec.describe ActiveRecord::LookML::Core do
  it "adds .enum_to_lookml method to ActiveRecord::Base" do
    expect(ActiveRecord::Base.enum_to_lookml).to eq ""
  end
end
