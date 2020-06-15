/**
 * Search algorithms for arrays of cards.
 */
public class Recursive {

    /**
     * Binary search (recursive version).
     */
    public static int binarySearch(Card[] cards, Card target,
                                   int low, int high) {
        System.out.println(low + ", " + high);

        if (high < low) {
            return -1;
        }
        int mid = (low + high) / 2;                     // step 1
        int comp = cards[mid].compareTo(target);

        if (comp == 0) {                                // step 2
            return mid;
        } else if (comp < 0) {                          // step 3
            return binarySearch(cards, target, mid + 1, high);
        } else {                                        // step 4
            return binarySearch(cards, target, low, mid - 1);
        }
    }

    public static void main(String[] args) {
        Card[] cards = makeDeck();
        Card jack = new Card(11, 0);

        System.out.println("Recursive binary search");
        System.out.println(binarySearch(cards, jack, 0, 51));
        System.out.println();
    }

}
