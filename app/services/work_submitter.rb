class WorkSubmitter
  attr_reader :work

  def initialize(work)
    @work = work
  end

  def call
    return false unless @work.save

    # launch processing...

    true
  end
end
