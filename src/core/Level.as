package core
{
  import __AS3__.vec.Vector;
  
  import mx.core.UIComponent;
  
  import units.Color;
  import units.EndArea;
  import units.RBC;
  import units.Virus;
  import units.WBC;
  
  import utils.LinkedList.LinkedList;
  import utils.Vector2;
  
  /** 
   * A game level. 
   */
  public class Level
  {
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
     * Set of interacting bodies in the map. 
     * The virus must be the first element of this list for proper collision detection.
     */
    public var bodies:LinkedList = new LinkedList();
    
    /** Set of end areas in the map. */
    public var endAreas:Vector.<EndArea> = new Vector.<EndArea>();
    
    /** Width of the map. */
    public var length:Number;
    
    /** Visual style of the map. */
    public var style:int = STANDARD;
    
    /** The ID of the next level. */
    public var nextLevel:int = -1;

    /**
     * Constructs a new level from XML level data. 
     * 
     * @param level - the XML level data.
     */
    public function Level(level:XML) {
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
        end.x = xml.x;
        end.y = xml.y;
        
        endAreas.push(end);
      }
      
      if (endAreas.length == 0) {
        throw new Error("Map contains no end areas.");
      }
      
      for each (xml in level.RBC) {
        var rbc:RBC = new RBC();
        rbc.setColors(Color.fromString(xml.color), Color.fromString(xml.dna));
        rbc.rotation = Math.random() * 360;
        
        var center:Vector2 = rbc.center;
        rbc.x = xml.x - center.x + rbc.width/2;
        rbc.y = xml.y - center.y + rbc.height/2;
        
        bodies.addLast(rbc);
      }
      
      for each (xml in level.WBC) {
        var wbc:WBC = new WBC();
        wbc.x = xml.x;
        wbc.y = xml.y;
        
        bodies.addLast(wbc);
      }
    }
    
    public function triggerEvents(gameState:Virus, container:UIComponent):void {
      // TODO
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // STATIC PROPERTIES & FUNCTIONS
    ///////////////////////////////////////////////////////////////////////////
    
    [Embed(source="assets/levels/0.xml", mimeType="application/octet-stream")] 
    private static const level0:Class;
    
    [Embed(source="assets/levels/1.xml", mimeType="application/octet-stream")] 
    private static const level1:Class;
    
    [Embed(source="assets/levels/2.xml", mimeType="application/octet-stream")] 
    private static const level2:Class;

    /**
     * Gets the XML data of a specified level.
     * 
     * @param level - the level number.
     * 
     * @return The XML.
     */
    public static function getLevel(level:int):XML {
      switch(level) {
        case 0: 
          return XML(new level0());
          break;
        case 1: 
          return XML(new level1());
          break;
        case 2:
          return XML(new level2());
          break;
        default:
          return null;
          break;
      }
    }

  }
}