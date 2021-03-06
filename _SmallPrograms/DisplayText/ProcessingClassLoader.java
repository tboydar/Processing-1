import java.net.URL;
import java.io.File;

import processing.core.PApplet;

/**
 * Class loader used only to load resources in typical Processing setup.
 * Default class loaders look in class path, ie. Processing libs and where the class files are,
 * typically in a randomly named build folder in system's temp dir.
 * This class loader looks in the sketch's data folder instead, because that's where
 * they are likely to be put and will be kept in an export.
 */
public class ProcessingClassLoader extends ClassLoader
{
  private PApplet m_pa;

  public ProcessingClassLoader(PApplet pa)
  {
    super();
    m_pa = pa;
  }

  @Override
  public URL getResource(String name)
  {
    String textPath = m_pa.dataPath(name);
//    System.out.println("getResource " + textPath);
    File textFile = new File(textPath);
    URL url = null;
    if (textFile.exists())
    {
      try
      {
        url = textFile.toURI().toURL();
      }
      catch (java.net.MalformedURLException e)
      {
        System.out.println("ProcessingClassLoader - Incorrect path: " + textPath);
      }
    }
    else
    {
      ClassLoader cl = getClass().getClassLoader();
      url = cl.getResource("data/" + name);
//      System.out.println("Using URL: " + url);
    }
    return url;
  }

  // Not necessary, mostly there to see if it is used...
  /*
  @Override
  public Class loadClass(String name, boolean resolve)
      throws ClassNotFoundException
  {
    System.out.println("loadClass: " + name);
    return findSystemClass(name);
  }
  */
}
