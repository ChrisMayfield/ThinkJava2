// partial solution to File I/O exercises
// implemented as a method instead of a constructor

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

    /**
     * Replaces grid based on a plain text file.
     * http://www.conwaylife.com/wiki/Plaintext
     * 
     * @param path the path to the file
     * @param margin how many cells to add
     */
    public void readFile(String path, int margin) {

        // open the file at the given path
        Scanner scan = null;
        try {
            File file = new File(path);
            scan = new Scanner(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            System.exit(1);
        }

        // read file contents into memory
        ArrayList<String> data = new ArrayList<String>();
        while (scan.hasNextLine()) {
            String line = scan.nextLine();
            // only add non-comment lines
            if (!line.startsWith("!")) {
                data.add(line);
            }
        }

        // determine number of rows and columns in the pattern
        int rows = data.size();
        int cols = 0;
        for (String line : data) {
            if (cols < line.length()) {
                cols = line.length();
            }
        }
        if (rows == 0 || cols == 0) {
            throw new IllegalArgumentException("no cells found");
        }

        // create the resulting grid with margin of extra cells
        grid = new GridCanvas(rows + 2 * margin, cols + 2 * margin, 20);
        for (int r = 0; r < rows; r++) {
            String line = data.get(r);
            for (int c = 0; c < line.length(); c++) {
                char x = line.charAt(c);
                if (x == 'O') {
                    grid.turnOn(r + margin, c + margin);
                }
            }
        }
    }
