(function(exports) {
  // convert number to hex with leading zero padding
  var hex = function(number, length) {
    var string = number.toString(16);
    while (string.length < (length || 2)) {
      string = '0' + string;
    }
    return string;
  };

  var variant = 6; // 110 in decimal
  var version = 0;
  var variantAndVersion = hex((variant << 5) | version);

  var nodeIdentifier = '';
  for (var count = 0; count < 6; count++) {
    nodeIdentifier += hex(Math.floor(Math.random() * 256));
  }

  var sequenceCounter = 0;
  var lastTime = -Infinity;

  exports.UUID = {
    next: function() {
      // just pad out to microseconds for now.
      var time = (new Date).getTime() * 1000;

      // handle the clock moving backwards.
      if (time < lastTime) time = lastTime;

      // handle multiple ids generated "simultaneously".
      if (time == lastTime) {
          if (sequenceCounter == 256) {
              // rather than block, we'll cheat and return a UUID from the very near future.
              lastTime = ++time;
              sequenceCounter = 0;
          } else {
              sequenceCounter++;
          }
      } else {
          lastTime = time;
          sequenceCounter = 0;
      }

      return [
        hex(time, 16),
        variantAndVersion,
        nodeIdentifier,
        hex(sequenceCounter)
      ].
        join('').
        // convert to standard aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee format
        match(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/).slice(1).join('-');
    }
  };
})(window);
