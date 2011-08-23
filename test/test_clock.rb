require 'shoulda'  

class DayGomiTest < Test::Unit::TestCase  
  context '#to_i' do  
    should "return 100" do  
      @total = '100'  
      assert_equal(100, @total.to_i)  
    end  
  end  
end  

