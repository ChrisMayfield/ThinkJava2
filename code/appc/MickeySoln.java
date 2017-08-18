import java.awt.Canvas;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Rectangle;
import javax.swing.JFrame;

/**
 * Solution code for Think Java (http://thinkapjava.com)
 *
 * Copyright(c) 2011 Allen B. Downey
 * GNU General Public License v3.0 (http://www.gnu.org/copyleft/gpl.html)
 *
 * @author Allen Downey
 * @version 6.5.0
 */
public class MickeySoln extends Canvas {

    public void boxOval(Graphics g, Rectangle bb) {
        g.fillOval(bb.x, bb.y, bb.width, bb.height);
    }

    public void mickey(Graphics g, Rectangle bb) {
        boxOval(g, bb);
        if (bb.width < 3) {
            return;
        }

        int dx = bb.width / 2;
        int dy = bb.height / 2;
        Rectangle half = new Rectangle(bb.x, bb.y, dx, dy);

        half.translate(-dx / 2, -dx / 2);
        mickey(g, half);

        half.translate(dx * 2, 0);
        mickey(g, half);
    }

    public void paint(Graphics g) {
        Rectangle bb = new Rectangle(100, 150, 200, 200);
        g.setColor(Color.gray);
        mickey(g, bb);
    }

    public static void main(String[] args) {
        // make the frame
        JFrame frame = new JFrame();
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // add the canvas
        Canvas canvas = new MickeySoln();
        canvas.setSize(400, 400);
        canvas.setBackground(Color.white);
        frame.getContentPane().add(canvas);

        // show the frame
        frame.pack();
        frame.setVisible(true);
    }
}
