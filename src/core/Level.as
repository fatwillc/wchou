package core
{
  import __AS3__.vec.Vector;
  
  import mx.controls.Image;
  
  import units.Color;
  import units.EndArea;
  import units.RBC;
  import units.WBC;
  
  import utils.LinkedList.LinkedList;
  import utils.Vector2;
  
  /** 
   * A game level. 
   * 
   * Contains level data as embedded XML assets. This is the only way I've 
   * found to load external XML files without baking them into code or storing
   * them remotely (due to Flash's sandbox security properties). As a result, 
   * there is a bit of resulting boilerplate code for loading the level data.
   */
  public class Level
  {
    private static const ASSET_DIRECTORY:String = "assets/levels/";
    
    ///////////////////////////////////////////////////////////////////////////
    // VISUAL STYLES ENUMERATION
    ///////////////////////////////////////////////////////////////////////////
    
    /** Standard level style (400 width, tiling background). */
    public static const STANDARD:int = 0;
    
    /** Title screen style. */
    public static const TITLE:int = 1;
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    //////////////////////////////////////////////////////////////////////////
    
    /** 
     * Interacting bodies in the map. 
     * The virus must be the first element of this list for proper collision detection.
     */
    public var bodies:LinkedList = new LinkedList();
    
    /** End areas in the map. */
    public var endAreas:Vector.<EndArea> = new Vector.<EndArea>();
    
    /** Width of the map. */
    public var length:Number;
    
    /** Foreground images in the map. */
    public var images:Vector.<Image> = new Vector.<Image>();
    
    /** Visual style of the map. */
    public var style:int = STANDARD;
    
    /** The ID of the next level. */
    public var nextLevel:int = -1;

    /**
     * Constructs a new level from XML level data. 
     * @param level - the XML level data.
     * @pararm levelNumber - the level number corresponding to the XML level.
     */
    public function Level(level:XML, levelNumber:int = -1) {
      try {
        length = Number(level.@length);
      } catch (e:Error) {
        throw new Error("Invalid level length.");
      }
      
      if ("@style" in level) {  
        switch (String(level.@style)) {
          case "title": 
            style = TITLE;
            break;
          default:
            style = STANDARD;
            break;
        }
      }
      
      if ("@nextLevel" in level) {
        try {
          nextLevel = Number(level.@nextLevel);
        } catch (e:Error) {
          throw new Error("Invalid next level ID.");
        }
      }
      
      var xml:XML;
      
      for each (xml in level.EndArea) {
        var end:EndArea = new EndArea();
        end.x = xml.@x;
        end.y = xml.@y;
        
        endAreas.push(end);
      }
      
      if (endAreas.length == 0) {
        throw new Error("Map contains no end areas.");
      }
      
      for each (xml in level.RBC) {
        var rbc:RBC = new RBC();
        rbc.setColors(Color.fromString(xml.@color), Color.fromString(xml.@dna));
        rbc.rotation = Math.random() * 360;
        
        var center:Vector2 = rbc.center;
        rbc.x = xml.@x - center.x + rbc.width/2;
        rbc.y = xml.@y - center.y + rbc.height/2;
        
        bodies.addLast(rbc);
      }
      
      for each (xml in level.WBC) {
        var wbc:WBC = new WBC();
        wbc.x = xml.@x;
        wbc.y = xml.@y;
        
        bodies.addLast(wbc);
      }
      
      for each (xml in level.Image) {
        var img:Image = new Image();
        img.source = ASSET_DIRECTORY + "/" + levelNumber + "/" + xml.@source;
        img.x = xml.@x;
        img.y = xml.@y;
        
        images.push(img);
      }
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // STATIC PROPERTIES & FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    
    [Embed(source="assets/levels/0/0.xml", mimeType="application/octet-stream")] 
    private static const level0:Class;
    
    [Embed(source="assets/levels/1/1.xml", mimeType="application/octet-stream")] 
    private static const level1:Class;
    
    [Embed(source="assets/levels/2/2.xml", mimeType="application/octet-stream")] 
    private static const level2:Class;

    /**
     * Gets the level data of a level number.
     * @param level - the level number.
     * @return The Level.
     */
    public static function getLevel(levelNumber:int):Level {
      switch(levelNumber) {
        case 0: 
          return new Level(XML(new level0()), levelNumber);
        case 1: 
          return new Level(XML(new level1()), levelNumber);
        case 2: 
          return new Level(XML(new level2()), levelNumber);
        default:
          return null;
      }
    }

  }
}