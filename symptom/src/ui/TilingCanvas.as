package ui
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.events.Event;
  
  import mx.containers.Canvas;
  import mx.controls.Image;

  public class TilingCanvas extends Canvas
  {
    private var image:Image = new Image();
    
    private var isLoadComplete:Boolean = false;
    
    public function TilingCanvas(imagePath:String = null)
    {
      super();
      
      image.addEventListener(Event.COMPLETE, onLoadComplete);
      
      if (imagePath != null)
        setTileImage(imagePath);
    }
    
    public function setTileImage(imagePath:String):void
    {
      isLoadComplete = false;
      image.load(imagePath);
    }
    
    private function onLoadComplete(e:Event):void
    {
      isLoadComplete = true;
      invalidateDisplayList();
    }
    
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      if (isLoadComplete)  {
        var bitmap:Bitmap = Bitmap(image.content);
        var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x000000);
        bitmapData.draw(bitmap);      
        
        graphics.clear();
        graphics.beginBitmapFill(bitmapData);
        graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
        graphics.endFill();
      }
    }
  }
}