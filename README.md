# SI::Unit

### Creation
```ruby
# base unit for SI::Power is kiloWatt
SI::Power.new(100)
SI::Power[100]

# unit can be specified at initialization
SI::Power.new(100, unit: :GW)
SI::Power[100, unit: :GW]

power = SI::Power.new(1, unit: :MW)
=> #<SI::Power 1 MW>
power.to_i
#=> 1000

SI::Energy.new(1000, unit: :Wh)
=> #<SI::Energy 1 kWh>
```

### Comparison
```ruby
SI::Power.new(1, unit: :MW) > SI::Power[100]
#=> true

SI::Energy.new(1, unit: :TWh) == SI::Energy.new(1_000_000_000_000, unit: :Wh) # !!
#=> true
```

### Human format
```ruby
power = SI::Power[100]
power.to_s
#=> "100 kW"

power = SI::Power[2000]
power.to_s
#=> "2 MW"

power = SI::Power[0.5]
power.to_s
#=> "500 W"

power = SI::Energy[100_000_000]
power.to_s
#=> "100 GWh"
```

### Conversions
```ruby
power = SI::Power[100]
power.convert_to(:kW)
#=> 100

power = SI::Power[100]
power.convert_to(:W)
#=> 100_000

power = SI::Energy[100_500_000]
power.convert_to(:GWh)
#=> 100.5
```

### Basic calculations
```ruby
SI::Power[100] + 200
#=> #<SI::Power 300 kW>

SI::Power[100] + SI::Power[200]
#=> #<SI::Power 300 kW>

SI::Power[100] - SI::Power[50]
#=> #<SI::Power 50 kW>

SI::Energy[100] * 2
#=> #<SI::Energy 200 kWh>

SI::Power[100] / 2
#=> #<SI::Power 100 kW>
```

### Advanced calculations
```ruby
SI::Power[100] * 2.hours
#=> #<SI::Energy 200 kWh>

SI::Power[100] * 30.minutes
#=> #<SI::Energy 50 kWh>


SI::Energy[500] / 5.hours
#=> #<SI::Power 100 kW>
# 100kW is the average power needed to produce 500kWh in 5 hours

SI::Energy[10000] / SI::Power[2500]
# => 4 hours
# 4 hours is the duration needed to produce 10 MWh with a power of 2.5MW
```
