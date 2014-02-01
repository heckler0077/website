class Event < ActiveRecord::Base
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :tags

  scope :enabled, -> { where(enabled: true) }
  scope :future, -> { enabled.where("time >=  ? OR recurring IS NOT NULL", Time.now) }
  scope :onetime, -> { enabled.where("recurring IS NULL") }
  scope :recurring, -> { enabled.where("recurring IS NOT NULL")}
  scope :next, ->(i) { future.order(:time).limit(i) }
  scope :tagged, ->(name) { joins(:tags).where('tags.name = ?', name) }

  def recurring
    value = read_attribute(:recurring)
    value = IceCube::Schedule.from_yaml value if value
    value
  end

  def recurring= schedule
    write_attribute(:recurring, schedule.to_yaml)
  end

  def next_occurrence
    if recurring
      recurring.next_occurrence
    elsif time >= Time.now
      time
    else
      nil
    end
  end
end