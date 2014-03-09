def hex(number, length=2)
  string = number.to_s(16)
  string = '0' + string while string.length < length
  string
end

module UUID
  class << self
    @@variant = 6
    @@version = 0
    @@variantAndVersion = hex((@@variant << 5) | @@version)

    @@nodeIdentifier = 6.times.map do |index|
      hex((rand * 256).floor)
    end.join

    @@sequenceCounter = 0
    @@lastTime        = -1.0/0.0

    def next
      # pad out to microseconds
      time = (Time.now.to_f * 1e6).floor

      # handle the clock moving backwards.
      time = @@lastTime if time < @@lastTime

      # handle multiple ids generated "simultaneously".
      if time == @@lastTime
        if @@sequenceCounter == 256
          # rather than block, we'll cheat and return a UUID from the very near future.
          @@lastTime = ++time
          @@sequenceCounter = 0
        else
          @@sequenceCounter += 1
        end
      else
        @@lastTime = time
        @@sequenceCounter = 0
      end

      [
        hex(time, 16),
        @@variantAndVersion,
        @@nodeIdentifier,
        hex(@@sequenceCounter)
      ].
        join().
        # convert to standard aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee format
        match(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/)[1..5].join('-')
    end
  end
end
