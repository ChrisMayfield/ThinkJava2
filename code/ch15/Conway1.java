// alternative constructor for Conway

    /**
     * Creates a grid with a Blinker and a Glider.
     */
    public Conway() {
        grid = new GridCanvas(30, 25, 20);
        grid.turnOn(1, 2);
        grid.turnOn(2, 2);
        grid.turnOn(3, 2);
        grid.turnOn(6, 1);
        grid.turnOn(7, 2);
        grid.turnOn(7, 3);
        grid.turnOn(8, 1);
        grid.turnOn(8, 2);
    }
