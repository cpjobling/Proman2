class Name
  attr_reader :title, :first, :initials, :last, :known_as
  
  def initialize(title, first, initials, last, known_as = "")
    @title = title
    @first = first
    @initials = initials
    @last = last
    @known_as = known_as
  end

  def to_s
    [ @title, @first, @initials, @last ].compact.join(" ")
  end

  def formally
    [ @title, @last ].compact.join(" ")
  end

  def informally
    if ( @known_as == "")
      return @first
    end
    return @known_as
  end

  # Apparently needed to satisfy assert_difference when testing composed objects?
  def size
    return 1
  end
end
