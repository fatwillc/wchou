package core
{
  import __AS3__.vec.Vector;
  
  import flash.events.EventDispatcher;
  import flash.ui.Keyboard;
  
  import mx.core.UIComponent;
  
  import units.*;
  import units.asteroids.*;
  import units.projectiles.*;
  import units.rocket.*;
  
  import utils.Geometry;
  import utils.Vector2;
  
  /**
   * A level contains a number of randomly generated asteroids and UFOs. 
   */
  public class Level extends EventDispatcher
  {
    /** Chance for a ufo to spawn on any given frame. */
    private const UFO_SPAWN_CHANCE:Number = 0.001;
    
    /** The graphics component of the level that holds all the game objects. */
    public function get container():UIComponent { return _container; }
    private var _container:UIComponent;
    
    /** The current level being played. */
    [Bindable] public var levelNumber:int = 0;
    
    /** Amount of money earned so far in current level. */
    [Bindable] public var moneyEarned:int = 0;
    
    /** Pointer to player's rocket. */
    private var rocket:Rocket;
    
    /** Set of projectiles in play. */      
    private var projectiles:Vector.<GameObject>;
    
    /** Set of asteroids in play. */
    private var asteroids:Vector.<GameObject>;
    
    /** Set of ufos in play. */
    private var ufos:Vector.<GameObject>;
    
    /**
     * Creates a new level.
     * 
     * @param container - the component that will house all game object graphics.
     * Must already exist.
     * @param level - the number of this level.
     * @param rocket - the player controlled rocket.
     */
    public function Level(container:UIComponent, level:int, rocket:Rocket)
    {
      this._container = container;
      this.levelNumber = level;
      this.rocket = rocket;

      projectiles = new Vector.<GameObject>();
      asteroids = new Vector.<GameObject>();
      ufos = new Vector.<GameObject>();
      
      // Add the rocket.
      rocket.levelReset(new Vector2(container.width / 2, container.height / 2));
      container.addChild(rocket.graphics);
      
      // Add asteroids.
      var numAsteroids:int = level * 2 + 1;
      for (var i:int = 0; i < numAsteroids; i++)
      {
        // Spawn asteroid in a random direction away from center of screen
        // between 150 and 300 units (makes sure not to instakill player).
        var asteroidPosition:Vector2 = new Vector2(container.width / 2, container.height / 2);
        asteroidPosition.acc(Vector2.randomUnitCircle(), Math.random() * 150 + 150);
  
        var asteroid:Asteroid = new LargeAsteroid(asteroidPosition);
        asteroids.push(asteroid);
        container.addChild(asteroid.graphics);
      }
    }
    
    /** Adds an array of asteroids into play. */
    private function addAsteroids(A:Vector.<Asteroid>):void 
    {
      if (A == null)
        return;
      
      for each (var asteroid:Asteroid in A)
      {
        asteroids.push(asteroid);
        container.addChild(asteroid.graphics);
      }
    }
    
    /** Updates the level and all contained game objects. */
    public function update(dt:Number, cameraTransform:Vector2):void
    {
      destroyObjects();

      checkVictoryLoss();
      
      generateProjectiles();
      
      processCollisions();
  
      generateUfos();
      
      updateObjects(dt, cameraTransform);
    }
    
    private function destroyObjects():void
    {
      // Filter destroyed objects.
      projectiles = projectiles.filter(GameObject.destroyFilter, container);
      asteroids = asteroids.filter(GameObject.destroyFilter, container);
      ufos = ufos.filter(GameObject.destroyFilter, container);
    }
    
    private function checkVictoryLoss():void
    {
      // Check for collision between the rocket and all other collidables.
      if (rocket.state == ObjectState.ACTIVE) 
      {
        for each (var a:Asteroid in asteroids)
        {
          if (Geometry.intersect(rocket, a) != null) 
          {
            rocket.die();
            addAsteroids(a.split());             
            break;
          }
        }
        
        for each (var ufo:Ufo in ufos)
        {
          if (Geometry.intersect(rocket, ufo) != null) 
          {
            rocket.die();
            ufo.die();
            break;
          }
        }
        
        for each (var p:Projectile in projectiles)
        {
          if (Geometry.intersect(rocket, p) != null) 
          {
            rocket.die();
            p.die();
            break;
          }
        }        
      }
      
      // Loss condition.
      if (rocket.state == ObjectState.DESTROY)
      {
        rocket.state = ObjectState.INACTIVE;
        dispatchEvent(new GameEvent(GameEvent.LOSE));
        return;
      }
        
      // Victory condition.
      if (rocket.state == ObjectState.ACTIVE && asteroids.length == 0)
      {
        rocket.state = ObjectState.INACTIVE;
        levelNumber += 1;
        dispatchEvent(new GameEvent(GameEvent.LOSE));
        return;
      }
    }
    
    private function generateProjectiles():void
    {
      // Rocket fire.
      if (InputState.isKeyDown(Keyboard.SPACE))
      {
        if (rocket.fire())
        {
          var bulletPosition:Vector2 = rocket.center;
          bulletPosition.acc(rocket.direction, rocket.radius * 2);
          
          var projectile:Projectile = new Bullet(bulletPosition, rocket.velocity, rocket.direction);
          projectiles.push(projectile);
          container.addChild(projectile.graphics);
        }
      }
      
      // Ufo fire.
      for each (var ufo:Ufo in ufos) 
      {
        if (ufo.fire())
        {
          // Fire at the rocket.
          var laserDirection:Vector2 = rocket.center.subtract(ufo.center);
          laserDirection.normalize();
          
          var laserPosition:Vector2 = ufo.center;
          laserPosition.acc(laserDirection, ufo.radius * 2.5);
          
          projectile = new Laser(laserPosition, ufo.velocity, laserDirection);
          projectiles.push(projectile);
          container.addChild(projectile.graphics);
        }
      }
    }
    
    private function processCollisions():void
    {
      // Bullet-? collisions.
      for each (var projectile:Projectile in projectiles)
      {
        for each (var asteroid:Asteroid in asteroids)
        {
          if (Geometry.intersect(asteroid, projectile) != null)       
          {  
            projectile.state = ObjectState.DESTROY;
            addAsteroids(asteroid.split());
            
            if (projectile is Bullet)
              moneyEarned += asteroid.reward;
              
            break;
          }
        }
        
        for each (var ufo:Ufo in ufos)
        {
          if (Geometry.intersect(ufo, projectile) != null)
          {
            ufo.die();
            projectile.state = ObjectState.DESTROY;
            
            if (projectile is Bullet)
              moneyEarned += ufo.reward;
              
            break;
          }  
        }
      }
      
      // Ufo-asteroid collisions.
      for each (var ufo:Ufo in ufos)
      {          
        for each (var asteroid:Asteroid in asteroids)
        {
          if (Geometry.intersect(ufo, asteroid) != null)
          {
            ufo.die();
            addAsteroids(asteroid.split());
            break;
          }
        }
      }
    }
    
    private function generateUfos():void
    {
      if (Math.random() < ((levelNumber + 2) / 2) * UFO_SPAWN_CHANCE) {
        var ufo:Ufo = new Ufo(Asteroids.randomOffscreenLocation(), rocket.center);
        ufos.push(ufo);
        container.addChild(ufo.graphics);
      }
    }
    
    private function updateObjects(dt:Number, cameraTransform:Vector2):void
    {
      rocket.step(dt, cameraTransform);
      
      for each (var ufo:GameObject in ufos) 
        ufo.step(dt, cameraTransform);
        
      for each (var a:Asteroid in asteroids) 
        a.step(dt, cameraTransform);
        
      for each (var p:Projectile in projectiles) 
        p.step(dt, cameraTransform);
    }

  }
}