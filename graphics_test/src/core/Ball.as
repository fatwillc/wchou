package core
{
  import flash.events.Event;
  import flash.geom.ColorTransform;
  
  import mx.controls.Image;
  import mx.events.FlexEvent;
  
  import physical.Circle;
  
  import utils.Vector2n;
  
  public class Ball extends GameObject
  {
    [Embed(source="assets/ball.swf")]
    private var ballSource:Class;
    
    /**
     * Creates a Ball at the given position with a random color.
     * 
     * @param position - the location to place the ball.
     */
    public function Ball(position:Vector2n)
    {
      super();
      
      // Wait for graphics load to complete before activating.
      state = ObjectState.INACTIVE;
      
      var image:Image = new Image();
      image.transform.colorTransform = new ColorTransform(0, 0, 0, 1, Math.random() * 255, Math.random() * 255, Math.random() * 255);
      image.addEventListener(mx.events.FlexEvent.INITIALIZE, initializeComplete);
      image.source = ballSource;
      
      graphics.drawable = image;

      physics.p.copy(position);
      physics.v = Vector2n.randomUnitCircle(Math.random() * 50);
    }
    
    private function initializeComplete(e:Event):void
    {
      var graphicsImage:Image = graphics.drawable as Image;
      
      var radius:Number = Math.min(graphicsImage.content.width, graphicsImage.content.height) / 2;
      physics.boundingCircle = new Circle(null, radius);

      state = ObjectState.ACTIVE;
    }
  }
}