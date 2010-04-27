package core
{
  import flash.events.Event;
  
  import graphical.GraphicsComponent;
  
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
      
      var image:Image = new Image();
      image.addEventListener(Event.COMPLETE, loadComplete);
      image.load("./assets/ball.swf");
      
      graphics.drawable = image;

      physics.p.copy(position);
      physics.v = Vector2.randomUnitCircle(Math.random() * 50);
    }
    
    private function loadComplete(e:Event):void
    {
      var graphicsImage:Image = graphics.drawable as Image;
      
      var radius:Number = Math.min(graphicsImage.content.width, graphicsImage.content.height) / 2;
      physics.boundingCircle = new Circle(null, radius);

      state = ObjectState.ACTIVE;
    }
  }
}