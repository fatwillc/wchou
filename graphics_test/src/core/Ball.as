package core
{
  import flash.events.Event;
  
  import mx.controls.Image;
  
  import physical.Circle;
  
  import utils.Vector2;
  
  public class Ball extends GameObject
  {    
    public function Ball(position:Vector2)
    {
      super();
      
      // Wait for graphics load to complete before activating.
      state = ObjectState.INACTIVE;
      
      _graphics = new Image();
      (graphics as Image).addEventListener(Event.COMPLETE, loadComplete);
      (graphics as Image).load("./assets/ball.swf");

      physics.p.copy(position);
      physics.v = Vector2.randomUnitCircle(Math.random() * 50);
    }
    
    private function loadComplete(e:Event):void
    {
      state = ObjectState.ACTIVE;
      
      var radius:Number = Math.min((graphics as Image).content.width, (graphics as Image).content.height) / 2;
      physics.boundingCircle = new Circle(null, radius);
    }
  }
}