# frozen_string_literal: true

module SI
  class Unit
    include Comparable

    PRECISION = 4

    SI_PREFIXES = {
      femto: "f",
      pico: "p",
      nano: "n",
      micro: "µ",
      milli: "m",
      # deci: "d",
      # centi: "c",
      unit: "",
      # deca: "da",
      # hecto: "h",
      kilo: "k",
      mega: "M",
      giga: "G",
      tera: "T",
      peta: "P"
    }.freeze

    HUMAN_UNIT_NAMES = [
      :femto,
      :pico,
      :nano,
      :micro,
      :mili,
      # :centi,
      # :deci,
      :unit,
      # :ten,
      # :hundred,
      :thousand,
      :million,
      :billion,
      :trillion,
      :quadrillion
    ].freeze

    class << self
      alias [] new

      def unit(symbol, base_prefix: :unit)
        human_units = build_human_units(symbol)
        const_set("HUMAN_UNITS", human_units)
        base_unit = "#{SI_PREFIXES[base_prefix]}#{symbol}".freeze
        define_method(:base_unit) { base_unit }
        define_method(:human_units) { human_units }
        private :human_units, :base_unit
      end

      def prefix_decimals(prefix)
        ActiveSupport::NumberHelper::NumberToHumanConverter::DECIMAL_UNITS.key(prefix)
      end

      def from_unit(value) = new(value, unit: self::HUMAN_UNITS[:unit])

      private

      def build_human_units(symbol)
        HUMAN_UNIT_NAMES.zip(SI_PREFIXES.keys).to_h.transform_values do |prefix_name|
          prefix = SI_PREFIXES.fetch(prefix_name)
          "#{prefix}#{symbol}".freeze
        end
      end
    end

    attr_reader :value

    def initialize(value, unit: base_unit)
      prefix = human_units.key(unit.to_s)
      @value = value * (10**Unit.prefix_decimals(prefix))
    end

    delegate :number_to_human, to: ActiveSupport::NumberHelper
    delegate :zero?, to: :value

    def convert_to(unit)
      prefix = human_units.key(unit.to_s)
      value.fdiv(10**Unit.prefix_decimals(prefix))
    end

    def +(other)
      case other
      when self.class
        new_from_raw(value + other.value)
      when 0
        new_from_raw(value)
      when Numeric
        raise TypeError, "Can't add or subtract a non-zero Integer value"
      else
        raise TypeError, "can't add #{other.class} to #{self.class}"
      end
    end

    def -(other)
      case other
      when self.class
        new_from_raw(value - other.value)
      when 0
        new_from_raw(value)
      when Numeric
        raise TypeError, "Can't add or subtract a non-zero Integer value"
      else
        raise TypeError, "can't substract #{other.class} to #{self.class}"
      end
    end

    def *(other)
      case other
      when Numeric
        new_from_raw(value * other)
      else
        raise TypeError, "can't multiply #{other.class} with #{self.class}"
      end
    end

    def /(other)
      case other
      when Numeric
        new_from_raw(value.fdiv(other))
      else
        raise TypeError, "can't divide by #{other.class}"
      end
    end

    def coerce(other) = [self, self.class[other]]
    def -@ = new_from_raw(-value)

    def eql?(other)
      return value == other.value if other.is_a?(self.class)

      false
    end

    def <=>(other)
      value <=> other.value if other.is_a?(self.class)
    end

    def to_s
      number_to_human(value, units: human_units, precision: PRECISION, format: "%n %u")
    end

    def inspect
      "#<#{self.class.name} #{self}>"
    end

    def new_from_raw(new_value) = self.class.from_unit(new_value)
  end
end
