package core
{
  import flash.events.Event;
  
  import mx.controls.Image;
  
  import utils.Vector2;
  
  public class Ball extends GameObject
  {    
    public function Ball(position:Vector2)
    {
      super();
      
      p.copy(position);
      
      this.v = Vector2.randomUnitCircle(Math.random() * 50);
      
      state = ObjectState.INACTIVE;
      
      _graphics = new Image();
      (graphics as Image).addEventListener(Event.COMPLETE, loadComplete);
      (graphics as Image).load("./assets/ball.swf");
    }
    
    private function loadComplete(e:Event):void
    {
      state = ObjectState.ACTIVE;
    }
    
  }
}