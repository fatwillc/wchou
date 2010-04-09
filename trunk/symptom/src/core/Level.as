package core
{
  import __AS3__.vec.Vector;
  
  import mx.controls.Image;
  
  import units.EndArea;
  import units.RBC;
  import units.Virus;
  import units.wbc.*;
  
  import utils.Geometry;
  import utils.Vector2;
  
  /** 
   * A game level. 
   * 
   * Contains level data as embedded XML assets. This is the only way I've 
   * found to load external XML files without baking them into code or storing
   * them remotely (due to Flash's sandbox security properties). As a result, 
   * there is a bit of boilerplate code for loading the level data.
   */
  public class Level
  {
    private static const ASSET_DIRECTORY:String = "assets/levels/";
    
    ///////////////////////////////////////////////////////////////////////////
    // VISUAL STYLES ENUMERATION
    //
    // Values contain path to background image for that style.
    ///////////////////////////////////////////////////////////////////////////
    
    /** Standard level style. */
    public static const STANDARD:String = "assets/levels/background_1.jpg";
    
    /** Title screen style. */
    public static const TITLE:String = "assets/levels/background_skin.jpg";
    
    ///////////////////////////////////////////////////////////////////////////
    // VARIABLES
    ///////////////////////////////////////////////////////////////////////////
    
    /** The virus. */
    private var virus:Virus = new Virus();
    
    /** Red blood cells in the map. */
    private var rbcs:Vector.<GameObject> = new Vector.<GameObject>();
    
    /** White blood cells in the map. */
    private var wbcs:Vector.<GameObject> = new Vector.<GameObject>();
    
    /** End areas in the map. */
    private var endAreas:Vector.<GameObject> = new Vector.<GameObject>();
    
    ///////////////////////////////////////////////////////////////////////////
    // PROPERTIES
    ///////////////////////////////////////////////////////////////////////////
    
    /** Current state of player playing this level. */
    public function get state():uint { return _state; }
    private var _state:uint = LevelState.PLAYING;
    
    /** Foreground images in the map. */
    public function get images():Vector.<Image> { return _images; }
    private var _images:Vector.<Image> = new Vector.<Image>();
    
    /** Length of the map. */
    public function get length():Number { return _length; }
    private var _length:Number;
    
    /** Visual style of the map. */
    public function get style():String { return _style; }
    private var _style:String = STANDARD;
    
    /** The ID of the next level. */
    public function get nextLevel():int { return _nextLevel; }
    private var _nextLevel:int = -1;
    
    /** The current position of the virus in the level. */
    public function get virusPosition():Vector2 { return virus.center; }
    
    ///////////////////////////////////////////////////////////////////////////
    // METHODS
    ///////////////////////////////////////////////////////////////////////////

    /**
     * Constructs a new level from XML level data. 
     * @param level - the XML level data.
     * @pararm levelNumber - the level number corresponding to the XML level.
     */
    public function Level(level:XML, levelNumber:int = -1) 
    {      
      try 
      {
        _length = Number(level.@length);
      } 
      catch (e:Error) 
      {
        throw new Error("Invalid level length.");
      }
      
      if ("@style" in level) 
      {  
        switch (String(level.@style)) 
        {
          case "title": 
            _style = TITLE;
            break;
          default:
            _style = STANDARD;
            break;
        }
      }
      
      if ("@nextLevel" in level) 
      {
        try 
        {
          _nextLevel = Number(level.@nextLevel);
        } 
        catch (e:Error) 
        {
          throw new Error("Invalid next level ID.");
        }
      }
      
      var xml:XML;
      
      for each (xml in level.EndArea) 
      {
        var end:EndArea = new EndArea();
        end.graphics.x = xml.@x;
        end.graphics.y = xml.@y;
        endAreas.push(end);
      }
      
      if (endAreas.length == 0) 
        throw new Error("Map contains no end areas.");
      
      for each (xml in level.RBC) 
      {
        var rbc:RBC = new RBC();
        rbc.setColors(Color.fromString(xml.@color), Color.fromString(xml.@dna));
        rbc.graphics.rotation = Math.random() * 360;
        
        var center:Vector2 = rbc.center;
        rbc.graphics.x = xml.@x - center.x + rbc.graphics.width/2;
        rbc.graphics.y = xml.@y - center.y + rbc.graphics.height/2;
        
        rbcs.push(rbc);
      }
      
      for each (xml in level.Hunter) 
      {
        var hunter:Hunter = new Hunter();
        hunter.graphics.x = xml.@x;
        hunter.graphics.y = xml.@y;
        wbcs.push(hunter);
      }
      
      for each (xml in level.Guard) 
      {
        var guard:Guard = new Guard();
        guard.graphics.x = xml.@x;
        guard.graphics.y = xml.@y;
        wbcs.push(guard);
      }      
      
      for each (xml in level.Image) 
      {
        var img:Image = new Image();
        img.source = ASSET_DIRECTORY + levelNumber + "/" + xml.@source;
        img.x = xml.@x;
        img.y = xml.@y;
        _images.push(img);
      }
      
      virus.graphics.x = 100;
      virus.graphics.y = Symptom.HEIGHT/2 - virus.graphics.height/2;
    }
    
    /** Updates the level and contained game objects. */
    public function update(dt:Number):void 
    {
      var virusCenter:Vector2    = virus.center;
      var virusDirection:Vector2 = virus.direction;
      var virusSpeed:Number      = virus.v.length();  
         
      /////////////////////////////////////////
      // CHECK VICTORY CONDITION
              
      for each (var end:EndArea in endAreas) 
      {            
        if (Geometry.intersect(virus, end) != null) 
        {
          _state = LevelState.WIN;
          return;
        }
      }
      
      /////////////////////////////////////////
      // REMOVE DESTROYED GAME OBJECTS
      
      rbcs = rbcs.filter(GameObject.filterDestroy);
      wbcs = wbcs.filter(GameObject.filterDestroy);
      
      var allObjects:Vector.<GameObject> = getAllObjects();
  
      ///////////////////////////////////////// 
      // WBC ATTRACTION FORCE
      
      for each (var go:GameObject in allObjects) 
      {
        if (go is WBC) 
        {
          if (!virus.isInfecting)
            (go as WBC).hunt(dt, virusCenter);
        }
      }
  
      /////////////////////////////////////////
      // PROCESS COLLISIONS
      
      var ks:Number = 25.0;
  
      for (var i:int = 0; i < allObjects.length; i++) 
      {
        var oi:GameObject = allObjects[i];
        
        for (var j:int = i+1; j < allObjects.length; j++) 
        {
          var oj:GameObject = allObjects[j];
          
          var normal:Vector2 = Geometry.intersect(oi, oj);
          if (normal != null) 
          {
            // Virus-specific collisions.
            // Note: Assumes that virus is the first element in the list of objects.
            if (oi is Virus) 
            {
              if (virus.isInfecting)
                break;
              
              if (oj is WBC) 
              {
                _state = LevelState.LOSE;
                return;
              }
              
              if (oj is RBC && normal.dot(virusDirection) > Geometry.COS_30 && virus.dna == (oj as RBC).color) 
              {
                virus.infect(oj as RBC);
                break;
              }
            }
            
            var d:Number = normal.length();
            normal.normalize();
            
            var relativeV:Vector2 = oi.v.subtract(oj.v);
            if (relativeV.dot(normal) < 0)
              continue;
              
            oi.F.acc(normal, -ks * d);
            oj.F.acc(normal,  ks * d);
          }
        }
      }
      
      /////////////////////////////////////////
      // UDPATE OBJECTS
      
      for each (var object:GameObject in allObjects)
        object.step(dt);
    }
    
    /** Gets all current objects in the level. */
    public function getAllObjects():Vector.<GameObject> 
    {
      // Push into a single vector; more performant than concat().
      var allObjects:Vector.<GameObject> = new Vector.<GameObject>();
      
      for each (var end:EndArea in endAreas) 
        allObjects.push(end);
      
      allObjects.push(virus);
      
      for each (var rbc:RBC in rbcs) 
        allObjects.push(rbc);
        
      for each (var wbc:WBC in wbcs) 
        allObjects.push(wbc);
         
      
      return allObjects;
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
    
    [Embed(source="assets/levels/3/3.xml", mimeType="application/octet-stream")] 
    private static const level3:Class;

    /**
     * Gets the level data of a level number.
     * @param level - the level number.
     * @return The Level.
     */
    public static function getLevel(levelNumber:int):Level 
    {
      switch(levelNumber) 
      {
        case 0: 
          return new Level(XML(new level0()), levelNumber);
        case 1: 
          return new Level(XML(new level1()), levelNumber);
        case 2: 
          return new Level(XML(new level2()), levelNumber);
        case 3: 
          return new Level(XML(new level3()), levelNumber);
        default:
          return null;
      }
    }

  }
}