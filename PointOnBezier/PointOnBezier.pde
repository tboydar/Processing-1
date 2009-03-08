/**
See if mouse cursor is over a Bézier curve.

by Philippe Lhoste <PhiLho(a)GMX.net> http://Phi.Lho.free.fr & http://PhiLho.deviantART.com
*/
/* File/Project history:
 1.01.000 -- 2008/09/01 (PL) -- Fixing some corner cases.
 1.00.000 -- 2008/08/27 (PL) -- Creation.
*/
/* Copyright notice: For details, see the following file:
http://Phi.Lho.free.fr/softwares/PhiLhoSoft/PhiLhoSoftLicence.txt
This program is distributed under the zlib/libpng license.
Copyright (c) 2008 Philippe Lhoste / PhiLhoSoft
*/

private static final int CURVE_NB = 7;
private static final boolean RANDOM_CURVES = true;
private static final int margin1 = 20;
private static final int margin2 = 50;

// Make some curves, for testing
BezierCurve[] curves = new BezierCurve[CURVE_NB];

void setup()
{
  size(400, 400);

  if (RANDOM_CURVES)
  {
    for (int i = 0; i < CURVE_NB; i++)
    {
      curves[i] = new BezierCurve(
          new Point(random(margin1, width - margin1), random(margin1, height - margin1)),
          new Point(random(width), random(height)),
          new Point(random(width), random(height)),
          new Point(random(margin1, width - margin1), random(margin1, height - margin1))
      );
    }
  }
  else
  {
    int i = 0;
    curves[i++] = new BezierCurve(
        new Point(width / 2 - margin1, height - margin1),
        new Point(margin1, 2 * margin2),
        new Point(width - margin1, 2 * margin2),
        new Point(width / 2 + margin1, height - margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(width / 3, margin1),
        new Point(margin1, 2 * margin2),
        new Point(width - margin1, 2 * margin2),
        new Point(2 * width / 3, margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(margin1, height - margin1),
        new Point(margin1, margin2),
        new Point(width - margin1, margin2),
        new Point(width - margin1, height - margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(margin1, height - margin1),
        new Point(width - margin2, height - margin1),
        new Point(margin1, margin1),
        new Point(width - margin1, margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(width - margin1, margin1),
        new Point(width - margin2, height - margin1),
        new Point(margin1, margin1),
        new Point(margin1, height - margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(margin1, margin1),
        new Point(width - margin2, margin1),
        new Point(margin1, height - margin1),
        new Point(width - margin1, height - margin1)
    );

    curves[i++] = new BezierCurve(
        new Point(width - margin1, height - margin1),
        new Point(width - margin2, margin1),
        new Point(margin1, height - margin1),
        new Point(margin1, margin1)
    );
  }
}


/**
 * Simple 2D point class with float storage.
 */
class Point
{
  private float m_x, m_y;

  Point(float x, float y)
  {
    m_x = x; m_y = y;
  }

  Point(Point p)
  {
    m_x = p.GetX(); m_y = p.GetY();
  }

  void SetLocation(float x, float y)
  {
    m_x = x; m_y = y;
  }
  void SetLocation(Point p)
  {
    m_x = p.GetX(); m_y = p.GetY();
  }

  float GetX() { return m_x; }
  float GetY() { return m_y; }
  float GetDist(Point p) { return dist(m_x, m_y, p.GetX(), p.GetY()); }

  String toString()
  {
    return "x=" + m_x + ", y=" + m_y;
  }
}


class BezierCurve
{
  Point m_startPoint, m_endPoint;
  Point m_startControlPoint, m_endControlPoint;
  Closest closest;
//boolean bDump = true;

  BezierCurve(Point startPoint, Point startControlPoint, Point endControlPoint, Point endPoint)
  {
    m_startPoint = startPoint;
    m_endPoint = endPoint;
    m_startControlPoint = startControlPoint;
    m_endControlPoint = endControlPoint;
  }

  /**
   * Gets a point on the Bézier curve, given a relative "distance" from the starting point,
   * expressed as a float number between 0 (start point) and 1 (end point).
   */
  Point GetPoint(float pos)
  {
    float x = bezierPoint(m_startPoint.GetX(), m_startControlPoint.GetX(),
        m_endControlPoint.GetX(), m_endPoint.GetX(),
        pos);
    float y = bezierPoint(m_startPoint.GetY(), m_startControlPoint.GetY(),
        m_endControlPoint.GetY(), m_endPoint.GetY(),
        pos);
    return new Point(x, y);
  }

  /**
   * Gets the tangent of a point (see GetPoint) on the Bézier curve, as an angle with positive x axis.
   * Uses Processing's bezierTangent, which is broken in 0135, and is fixed in 0136 and higher.
   */
  float GetTangent(float pos)
  {
    float x = bezierTangent(m_startPoint.GetX(), m_startControlPoint.GetX(),
        m_endControlPoint.GetX(), m_endPoint.GetX(),
        pos);
    float y = bezierTangent(m_startPoint.GetY(), m_startControlPoint.GetY(),
        m_endControlPoint.GetY(), m_endPoint.GetY(),
        pos);
    return atan2(y, x);
  }

  void Draw()
  {
    bezier(m_startPoint.GetX(), m_startPoint.GetY(),
        m_startControlPoint.GetX(), m_startControlPoint.GetY(),
        m_endControlPoint.GetX(), m_endControlPoint.GetY(),
        m_endPoint.GetX(), m_endPoint.GetY());
  }

  /**
   * Visualizes control points.
   */
  void DrawControls()
  {
    noFill();
    stroke(#FF8000);
    strokeWeight(1);

    line(m_startPoint.GetX(), m_startPoint.GetY(), m_startControlPoint.GetX(), m_startControlPoint.GetY());
    ellipse(m_startControlPoint.GetX(), m_startControlPoint.GetY(), 4, 4);

    line(m_endPoint.GetX(), m_endPoint.GetY(), m_endControlPoint.GetX(), m_endControlPoint.GetY());
    ellipse(m_endControlPoint.GetX(), m_endControlPoint.GetY(), 4, 4);
  }

  void DrawDetails(int pointNb, float tanLength)
  {
    if (pointNb <= 1) pointNb = 2;
    stroke(#FF0000);
    strokeWeight(1);

    for (int i = 0; i < pointNb; i++)
    {
      float pos = (float) i / (pointNb - 1);

      Point pt = GetPoint(pos);
      float x = pt.GetX(), y = pt.GetY();
      float a = GetTangent(pos);

      line(x, y, cos(a) * tanLength + x, sin(a) * tanLength + y);
      ellipse(x, y, 3, 3);

      ellipse(x, y, 3, 3);
    }
  }

  void DrawClosestPoint()
  {
    if (closest == null) return;
    fill(#FFFF00);
    stroke(#FF0000);
    strokeWeight(1);
    Point p = closest.GetPoint();
    ellipse(p.GetX(), p.GetY(), 4, 4);
  }

  boolean IsPointOnCurve(Point p)
  {
    // We start at each extremity of the curve
    closest = GetClosest(p, 0.0, 1.0);
    do
    {
      // Exit
      if (closest.IsFound())
        return closest.IsOnCurve();
      // Iterate on the closest range
      closest = GetClosest(p, closest.GetStart(), closest.GetEnd());
    } while (true); // Rely on internal exits
  }

  /**
   * Simple class to wrap multiple return values.
   */
  class Closest
  {
    float m_r1, m_r2; // Current range on curve
    Point m_p;  // If no longer null, it is the point on the curve closest of the searched point
    boolean m_b;  // If true, it means the closest point is on curve
    Closest(float r1, float r2)
    {
      m_r1 = r1; m_r2 = r2;
    }
    Closest(Point p, boolean b)
    {
      m_p = p;
      m_b = b;
    }
    float GetStart() { return m_r1; }
    float GetEnd() { return m_r2; }
    Point GetPoint() { return m_p; }
    boolean IsFound() { return m_p != null; }
    boolean IsOnCurve() { return m_b; }
  }

  /**
   * Search the point on the curve which is the closest of the given point p.
   * Actually search only between the two given ranges r1 and r2.
   * The idea is to reduce the range until it is to the size of a pixel: either the pixel
   * corresponds to the given point, and we found that the point is on the curve, or it is
   * distant of several pixels of the point, so the point is outside.
   * We reduce the range with dichotomy: split it in two (ie. three points) and see
   * which point of the two extremities are closest of the target. The new range is the
   * middle point and the closest point.
   */
  private Closest GetClosest(Point p, float r1, float r2)
  {
    // Compute middle of the range
    float mr = (r1 + r2) / 2;
    Point p1, mp, p2; float d1, md, d2;
    // Compute the points at each extremity of the range and in the middle
    p1 = GetPoint(r1); mp = GetPoint(mr); p2 = GetPoint(r2);
    // Compute the distances between these points and the target point
    d1 = p.GetDist(p1); md = p.GetDist(mp); d2 = p.GetDist(p2);
    // If one of these distances is below 1, these two points are in the same pixel: we found it!
    if (d1 < 1.0) return new Closest(p1, true);
    else if (md < 1.0) return new Closest(mp, true);
    else if (d2 < 1.0) return new Closest(p2, true);
    // If one point of the extremities of the range  is within the same pixel as the middle,
    // we got the smallest possible range, so we failed (point not on curve)
    if (p1.GetDist(mp) < 1.0 || mp.GetDist(p2) < 1.0)
      return new Closest(mp, false);
    // Take the biggest distance
    float mxd = max(d1, md, d2);
    // If it is the first one, we will use the second range
    if (mxd == d1) return new Closest(mr, r2);
    // If it is the second one, we will use the first range
    else if (mxd == d2) return new Closest(r1, mr);
    else
    {
      // If that's the middle point which is the farthest of the target point,
      // we take again the range whose extremity is the closest
      if (d1 > d2) return new Closest(mr, r2);
      else return new Closest(r1, mr);
    }
  }
}


void draw()
{
  background(#AAAAAA);

  for (int i = 0; i < CURVE_NB; i++)
  {
//    curves[i].DrawControls();

    // Show Bézier curve
    noFill();
    if (curves[i].IsPointOnCurve(new Point(mouseX, mouseY)))
    {
      stroke(#FF80FF);
    }
    else
    {
      stroke(#8080FF);
    }
    strokeWeight(3);
    curves[i].Draw();
    curves[i].DrawClosestPoint();

//    curves[i].DrawDetails(10, 30);
  }
}
