// http://xmlgraphics.apache.org/batik/using/svg-generator.html

import java.awt.Rectangle;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.Dimension;

import java.io.Writer;
import java.io.OutputStreamWriter;
import java.io.IOException;

import org.apache.batik.svggen.SVGGraphics2D;
import org.apache.batik.svggen.SVGGeneratorContext;
import org.apache.batik.svggen.ImageHandler;
import org.apache.batik.svggen.GenericImageHandler;
import org.apache.batik.svggen.CachedImageHandlerBase64Encoder;
import org.apache.batik.svggen.ImageHandlerPNGEncoder;
import org.apache.batik.svggen.ImageHandlerJPEGEncoder;
import org.apache.batik.dom.GenericDOMImplementation;

import org.w3c.dom.Document;
import org.w3c.dom.DOMImplementation;

public class TestSVGGen
{
    static boolean bEmbedFonts = true;
    static boolean bEmbedImages = true;

    public void paint(Graphics2D g)
    {
        g.setPaint(Color.green);
        g.fill(new Rectangle(30, 10, 150, 100));
        g.setPaint(Color.black);
        g.drawString("PGraphicsSVG", 45, 65);

        // Do some drawing.
        Shape circle = new Ellipse2D.Double(20, 110, 50, 50);
        g.setPaint(Color.red);
        g.fill(circle);
        g.translate(60, 0);
        g.setPaint(Color.blue);
        g.fill(circle);
        g.translate(60, 0);
        g.setPaint(Color.orange);
        g.fill(circle);
    }

    public static void main(String[] args) throws IOException
    {
        // Get a DOMImplementation.
        DOMImplementation domImpl =
                GenericDOMImplementation.getDOMImplementation();

        // Create an instance of org.w3c.dom.Document.
        String svgNS = "http://www.w3.org/2000/svg";
        Document document = domImpl.createDocument(svgNS, "svg", null);

        // Create an instance of the SVG Generator.
        SVGGeneratorContext ctx = SVGGeneratorContext.createDefault(document);

        // General file comment
        ctx.setComment(" Generated by Processing with the PGraphicsSVG library ");
        // Allow to embed fonts
        ctx.setEmbeddedFontsOn(bEmbedFonts);
        // Image options
        if (bEmbedImages)
        {
            // Reuse our embedded base64-encoded image data.
            GenericImageHandler ihandler = new CachedImageHandlerBase64Encoder();
            ctx.setGenericImageHandler(ihandler);
        }
        else
        {
            // Don't embed images, save to the pointed directory
            ImageHandler ihandler = new ImageHandlerPNGEncoder("", null); // "res/images"
            // or
//~             ihandler = new ImageHandlerJPEGEncoder("", null); // "res/images"
            ctx.setImageHandler(ihandler);
        }

        SVGGraphics2D g2d = new SVGGraphics2D(ctx, false);
        g2d.setSVGCanvasSize(new Dimension(250, 200));

        // Ask the test to render into the SVG Graphics2D implementation.
        TestSVGGen test = new TestSVGGen();
        test.paint(g2d);

        // Finally, stream out SVG to the standard output using
        // UTF-8 encoding.
        boolean useCSS = true; // we want to use CSS style attributes
        Writer out = new OutputStreamWriter(System.out, "UTF-8");
        g2d.stream(out, useCSS);
    }
}
