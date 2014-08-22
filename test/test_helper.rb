require 'weesked'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'fakeredis'


MONDAY_SUNDAY_12_14 = {
  sunday: [ '12', '13', '14' ],
  monday: [ '12', '13', '14' ],
  tuesday: [ '12', '13', '14' ],
  wednesday: [ '12', '13', '14' ],
  thursday: [ '12', '13', '14' ],
  friday: [ '12', '13', '14' ],
  saturday: [ '12', '13', '14' ],
}.freeze

EMPTY_AVAIL = {
  monday: [ ],
  tuesday: [ ],
  wednesday: [ ],
  thursday: [ ],
  friday: [ ],
  saturday: [ ],
  sunday: [ ]
}

MONDAY_TUESDAY_12_14 = {
  monday: [ '12', '13', '14' ],
  tuesday: [ '12', '13', '14' ],
  wednesday: [  ],
  thursday: [  ],
  friday: [  ],
  saturday: [  ],
  sunday: [  ]
}

TUESDAY_12_14 = {
  monday: [  ],
  tuesday: [ '12', '13', '14' ],
  wednesday: [ ],
  thursday: [ ],
  friday: [ ],
  saturday: [ ],
  sunday: [ ]
}