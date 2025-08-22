/**
 * Think Java exercises 8.3, 8.4, and 8.5.
 *
 * @author Chris Mayfield
 * @version 6.5.0
 */
public class Ch8 {

    /**
     * Returns the sum of odd integers from 1 to n.
     */
    public static int oddSum(int n) {
        System.out.println("n is " + n);  // for debugging
        if (n < 1) {  // base case
            return 0;
        }
        if (n % 2 == 0) {  // n is even
            return oddSum(n - 1);
        }
        // at this point, n is odd and >= 1
        return n + oddSum(n - 2);
    }

    /**
     * Computes the Ackermann function.
     */
    public static int ack(int m, int n) {
        System.out.printf("m=%d n=%d\n", m, n);  // for debugging
        // only defined for non-negative integers
        if (m < 0 || n < 0) {
            return -1;
        }
        // base case
        if (m == 0) {
            return n + 1;
        }
        // at this point, we know m > 0
        if (n == 0) {
            return ack(m - 1, 1);
        }
        // at this point, we know m > 0 and n > 0
        return ack(m - 1, ack(m, n - 1));
    }

    /**
     * Returns x raised to the n power.
     */
    public static double power(double x, int n) {
        System.out.printf("x=%.1f n=%d\n", x, n);  // for debugging
        if (n == 0) {
            return 1;
        }
        // optional challenge: when n is even
        if (n % 2 == 0) {
            double temp = power(x, n / 2);
            return temp * temp;
        }
        // general case (when n is odd)
        return x * power(x, n - 1);
    }

    /**
     * Tests the above methods.
     */
    public static void main(String[] args) {
        System.out.println("oddSum(10) is " + oddSum(10) + " (should be 25)\n");
        System.out.println("oddSum(15) is " + oddSum(15) + " (should be 64)\n");

        System.out.println("ack(1, 2) is " + ack(1, 2) + " (should be 4)\n");
        System.out.println("ack(3, 1) is " + ack(3, 1) + " (should be 13)\n");

        System.out.println("power(5.0, 5) is " + power(5.0, 5)
                               + " (should be 3125.0)\n");
        System.out.println("power(5.0, 6) is " + power(5.0, 6)
                               + " (should be 15625.0)\n");
    }

}
