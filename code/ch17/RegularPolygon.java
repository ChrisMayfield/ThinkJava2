// Exercise 17.1

    public static final String[] NAMES = {null, null, null,
            "Triangle", "Square", "Pentagon", "Hexagon",
            "Heptagon", "Octagon", "Nonagon", "Decagon"};

    @Override
    public String toString() {
        StringBuilder str = new StringBuilder();
        if (npoints < NAMES.length) {
            str.append(NAMES[npoints]);
        } else {
            str.append("Polygon");
        }
        // append the list of vertexes
        str.append('[');
        for (int i = 0; i < npoints; i++) {
            if (i > 0) {
                str.append(", ");
            }
            // append the next (x, y) point
            str.append('(');
            str.append(xpoints[i]);
            str.append(", ");
            str.append(ypoints[i]);
            str.append(')');
        }
        str.append(']');
        return str.toString();
    }
