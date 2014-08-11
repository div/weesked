# Weesked

Simple weekely schedule based on redis lists

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weesked'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weesked

## Setup

  Weesked need Redis.current to return your redis instance

## Usage

Let's say that we run some small buisness, we've got several employees which provide some service to our customers. Customers book appointments with our employees. But each employee has her personal week schedule. Some work in the morning, some on weekends etc. So you want to know if this employee is availiable on tuesday at 18.00. We need to check his appointments if he is free at that time, and also we need to check his schedule if he is even availiable on that day. Figuring out appointments is easy - we've got postgres ranges for that. But the weekly schedule is a bit trickier. We could use the same ranges approach to make availibility schedule for the comming weeks, but we'll have to maintain some process to keep this shcedule updated and so on. Other option is to use some scheduling lib like ice_cube. But you wont be able to query all your employees availiability easely.

Here comes weesked - redis weekly scheduler. Schedule is an array of redis lists, each list corresponds to time period in some incremets let's say an hour for now. So our week consists of 24*7=168 lists. We add our employee to a list to mark that she's not availiable at that time.

```ruby
class Employee
  include Weesked::Schedule

  def self.weesked_schedule_key
    "weesked:#{class_name.downcase}"
    # by default each class has it's own schedule
    # you can set same key for different classes to share same schedule
  end

  def id
    # rails got that for you
  end

  def weesked_key
    "#{class.class_name.downcase}:#{id}"
    # that's defefault - fill free to override
  end

end
```

Including Weesked::Schedule module gives you the folowing:

```ruby
employee = Employee.new

employee.schedule
=> {monday: [1, 2, 5, 6, 9], tuesday: [0, 18, 25], ...}

employee.schedule = {monday: [1, 2, 5, 6, 9], tuesday: [0, 18, 25], ...}
=> {monday: [1, 2, 5, 6, 9], tuesday: [0, 18, 25], ...}

employee.availiable? Time.now
=> true

Employee.availiable Time.now
=> [1, 3, 18]
# employee ids

Employee.availiable 10.hours.from_now..12.hours.from_now
=> [3, 12]
```

So if we're using rails with postgres and want to get the employees availiable and without appointments, you might do something like that:

```ruby
time_range = 10.hours.from_now..12.hours.from_now
booked_employees = Employee.joins(:appointments).merge(Appointment.booked_on(time_range))
availiable_employees = Eployee.where id: Employee.availiable(time_range)
```
Now you'll have to extract the first from the second to get those which are free at this time range.
Or you can do combine it in a single query (not sure how to do it in AR) and assign to a scope:

```ruby
  scope :free, -> (range) {
    from("
      (
        (
          #{Employee.availiable(range).to_sql}
        )
        except
        (
          #{Employee.booked_on(range).to_sql}
        )
      ) #{Employee.table_name}
    ")
  }
```

## Config

You might want to customize method names and/or time step if you need more granularity in your schedule.
You coluld throw this in an initializer or just config where ever suits your needs.

```ruby
Weesked.setup do |config|
  # ...
  # Configures the methods needed by weesked
  config.schedule_method = :schedule
  config.availiable_method = :availiable

  # Configures the default stuff about days and steps
  config.time_step = 1.hour
  config.availiable_days = %w(sunday monday tuesday wednesday thursday friday saturday)
  config.availiable_steps = (9..18).to_a  # if your step is 1.hour i'ts typical workours
  config.steps_day_shift = 3  # number of steps if you want 2am on tuesday still be 'on monday'
  # it's only needed if in you UI you want users to pick availiability on monday: from 18pm to 2am
  # we make it easier to do so with day_shift
  # ...
end

Redis.current = Redis.new(url: '//127.0.0.1:6379/1')
# but it's better to put redis initialization in it's own initializer
```
But keep in mind that .schedule will return indexes of your new steps within a day. So if you set step to 15.minutes you'll have 96 periods in a day [0,95] and so on.


## Contributing

1. Fork it ( https://github.com/div/weesked/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
