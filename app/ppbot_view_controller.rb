class PPBotViewController < UIViewController
  attr_accessor :state

  def loadView
    self.view = UIImageView.alloc.init
  end

  def viewDidLoad
    view.image = UIImage.imageNamed("background.png")

    create_title

    top = 310

    @q1 = UILabel.new
    @q1.font = UIFont.systemFontOfSize(20)
    @q1.text = '(initial)'
    @q1.textAlignment = UITextAlignmentCenter
    @q1.textColor = UIColor.darkGrayColor
    @q1.backgroundColor = UIColor.clearColor
    @q1.frame = [[margin, top+48], [view.frame.size.width - margin * 2, 30]]
    view.addSubview(@q1)

    @q2 = UILabel.new
    @q2.font = UIFont.systemFontOfSize(20)
    @q2.text = '(initial)'
    @q2.textAlignment = UITextAlignmentCenter
    @q2.textColor = UIColor.darkGrayColor
    @q2.backgroundColor = UIColor.clearColor
    @q2.frame = [[margin, top+78], [view.frame.size.width - margin * 2, 30]]
    view.addSubview(@q2)

    midway = view.frame.size.width / 2
    width_less_margins = view.frame.size.width - 2*margin
    full_button_size = [width_less_margins, 40]
    half_button_size = [width_less_margins/2 - margin/2, 40]

    @yes_button = make_button("Yes", "yesTapped", green)
    @yes_button.frame = [[margin, top+2*60], half_button_size]
    view.addSubview(@yes_button)

    @no_button = make_button("No", "noTapped", red)
    @no_button.frame = [[midway+margin/2, top+2*60], half_button_size]
    view.addSubview(@no_button)

    @done_button = make_button("Done", "doneTapped", blue)
    @done_button.frame = [[margin, top+2*60], full_button_size]
    view.addSubview(@done_button)

    @previousGesture = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'swipeGesture:')
    @previousGesture.direction = UISwipeGestureRecognizerDirectionLeft
    view.addGestureRecognizer(@previousGesture)

    @nextGesture = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'swipeGesture:')
    @nextGesture.direction = UISwipeGestureRecognizerDirectionRight
    view.addGestureRecognizer(@nextGesture)

    view.userInteractionEnabled = true
    restart
  end

  def yesTapped
    @state.yes(self)
    transition
  end

  def noTapped
    @state.no(self)
    transition
  end

  def doneTapped
    @state.yes(self)
    transition
  end

  def transition
    delay = 0.25
    @state.establish(self)
    show_buttons
  end

  def restart
    @state = States::HaveTestState.instance
    @state.establish(self)
    show_buttons
  end

  def swipeGesture(gesture)
    @state = States::HaveTestState.instance
    transition
  end

  def ask(question)
    set_text(question)
    @asking = true
  end

  def doit(action, more_action=nil)
    set_text(action, more_action)
    @asking = false
  end

  def show_buttons
    @yes_button.hidden  = ! @asking
    @no_button.hidden   = ! @asking
    @done_button.hidden = @asking
  end

  def set_text(text1, text2=nil)
    if text2
      @q1.hidden = false
      @q1.text = text1
      @q2.text = text2
    else
      @q1.hidden = true
      @q1.text = ""
      @q2.text = text1
    end
  end

  def margin
    @margin ||= 30
  end

  def blue
    @blue ||= UIColor.colorWithRed(0.10, green: 0.10, blue: 0.70, alpha: 1.0)
  end

  def red
    @red ||= UIColor.colorWithRed(0.60, green: 0.10, blue: 0.10, alpha: 1.0)
  end

  def green
    @green ||= UIColor.colorWithRed(0.10, green: 0.60, blue: 0.10, alpha: 1.0)
  end

  private

  def make_button(title, action, color)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(title, forState:UIControlStateNormal)
    button.setTitleColor(color, forState:UIControlStateNormal)
    button.setTitle(title, forState:UIControlStateSelected)
    button.addTarget(self, action:action, forControlEvents:UIControlEventTouchUpInside)
    button
  end


  def create_title
    @title_y = 30
    @title1 = create_title_label("Pair Programming Bot")
  end

  def create_title_label(text)
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(26)
    label.text = text
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.blackColor
    label.backgroundColor = UIColor.clearColor
    label.frame = [[margin, @title_y], [view.frame.size.width - margin * 2, 45]]
    view.addSubview(label)
    @title_y += 45
    label
  end
end
