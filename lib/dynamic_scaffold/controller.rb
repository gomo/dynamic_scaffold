module DynamicScaffold
  module Controller
    def index
      @test_var = 'foobar'
      render 'dynamic_scaffold/index'
    end
  end
end
