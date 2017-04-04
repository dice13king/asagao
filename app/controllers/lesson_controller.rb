class LessonController < ApplicationController
  before_action :set_message, only: :step7
  def step1
    render text:"こんにちは、#{params["name"]}さん"
  end
  def step3
    redirect_to action: "step4"
  end

  def step4
    render text: "step4に移動したぜ"
  end

  def step7
    render text: @message
  end

  def step8
    @price = (2000 * 1.05).floor
  end
  def step10
    @comment = "&ltscript&rtalert('危険！')</script>こんにちは。"
  end
  def step11
    @comment = "<strong>安全なHTML</strong>"
  end

  private
  def set_message
    @message = "あざーす"
  end
end
