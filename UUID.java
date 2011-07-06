import java.security.SecureRandom;

public final class UUID {
    private static long lastTime = Long.MIN_VALUE;
    // use a short instead of a byte to work around Java's lack of unsigned types.
    private static short sequenceCounter = 0;
    
    private static long versionIdentifier = 0xC000000000000000L;
    private static long versionAndNodeIdentifier;

    static {
        // generate a random number for the node identifier.
        SecureRandom random = new SecureRandom();
        long nodeIdentifier = (random.nextLong() & 0x0000FFFFFFFFFFFFL) << 8;
        versionAndNodeIdentifier = versionIdentifier | nodeIdentifier;
    }
    
    public static synchronized java.util.UUID next() {
        // just pad out to microseconds for now.
        long time = System.currentTimeMillis() * 1000;
        
        // handle the clock moving backwards.
        if (time < lastTime) time = lastTime;
        
        // handle multiple ids generated "simultaneously".
        if (time == lastTime) {
            if (sequenceCounter == 256) {
                // rather than block, we'll cheat and return a UUID from the very near future.
                lastTime = time++;
                sequenceCounter = 0;
            } else {
                sequenceCounter++;
            }
        } else {
            lastTime = time;
            sequenceCounter = 0;
        }
        
        return new java.util.UUID(time, versionAndNodeIdentifier | (sequenceCounter & 0xFF));
    }
    
    // helper functions for comparing a UUID to a time range.
    
    public static java.util.UUID from(long time) {
        return new java.util.UUID(time, versionIdentifier);
    }
    
    public static java.util.UUID until(long time) {
        return new java.util.UUID(time, versionIdentifier | 0x00FFFFFFFFFFFFFFL);
    }
}
