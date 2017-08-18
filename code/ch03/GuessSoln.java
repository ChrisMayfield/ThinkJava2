import java.util.Scanner;
import java.util.Random;

/**
 * Solution code for the "guess my number" exercise.
 *
 * @author Allen Downey
 * @version 6.5.0
 */
public class GuessSoln {

    public static void main(String[] args) {
        // create a scanner
        Scanner in = new Scanner(System.in);

        // pick a random number
        Random random = new Random();
        int number = random.nextInt(100) + 1;

        // display the prompt
        System.out.println("I'm thinking of a number between 1 and 100");
        System.out.println("(including both).  Can you guess what it is?");
        System.out.print("Type a number: ");

        // parse input from the user
        String line = in.nextLine();
        int guess = Integer.parseInt(line);

        // display the results
        System.out.println("Your guess is: " + guess);
        System.out.println("The number I was thinking of is: " + number);
        System.out.println("You were off by: " + (guess - number));

        // note: what happens if you don't have parens around guess - number?
    }
}
