    public static double circleArea
            (double xc, double yc, double xp, double yp) {
        double radius = distance(xc, yc, xp, yp);
        double area = calculateArea(radius);
        return area;
    }

    public static double calculateArea
            (double xc, double yc, double xp, double yp) {
        return calculateArea(distance(xc, yc, xp, yp));
    }


        System.out.println("circleArea");
        System.out.println(circleArea(1.0, 2.0, 4.0, 6.0));

        System.out.println("calculateArea with 4 doubles");
        System.out.println(calculateArea(1.0, 2.0, 4.0, 6.0));

