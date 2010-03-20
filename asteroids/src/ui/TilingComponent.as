package ui
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  import mx.controls.Image;
  import mx.core.UIComponent;
  
  import utils.Vector2;
  
  /**
   * A UIComponent with a self-tiling, movable background.
   */ 
  public class TilingComponent extends UIComponent
  {
    /** 
     * Current tiled image offset.
     * E.g. if offset = (0, 200), then the image is shifted down 200 pixels.
     * Since this component tiles the image, the resulting gap with a height of 
     * 200 pixels will be filled in by the portion of the image that just went off-screen.
     */
    private var offset:Vector2 = new Vector2();
  
    /** Image to tile. */
    public function set tileImage(tileImage:Image):void { _tileImage = tileImage; }
    private var _tileImage:Image;

    /** Reset to initial state. */
    public function reset():void 
    {
      offset.zero();
    }
    
    /** 
     * Updates the tile offset (shifts the tiled image by the specified vector). 
     * 
     * @param shift - the vector to shift the current tiled image by.
     */
    public function update(shift:Vector2):void 
    {
      offset.acc(shift, 1);
      
      invalidateDisplayList();
    }
  
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
      super.updateDisplayList(unscaledWidth, unscaledHeight);
      
      var w:Number = unscaledWidth;
      var h:Number = unscaledHeight;
      
      if (_tileImage == null)
        throw new Error("Image to tile has not been set yet.");
        
      // Tiling is separable, so it is accomplished simply by tiling first in
      // the vertical direction, and then in the horizontal direction.
        
      var _imageData:BitmapData = Bitmap(_tileImage.content).bitmapData;
      
      // The direction (+/- 1) of the offset.
      var sign:Point = new Point(offset.x / Math.abs(offset.x), offset.y / Math.abs(offset.y));
      
      // Reduce/simplify offset to [(-w,-h), (w,h)]. 
      // This is because the tiled result of offset += N * size are equivalent,
      // i.e. tiling by 1.5 screens is the same as tiling by 0.5 screens.
      while (Math.abs(offset.x) > w)
        offset.x -= sign.x * w;
        
      while (Math.abs(offset.y) > h)
        offset.y -= sign.y * h;
  
      // First tile image on the Y-axis.
      var tileY:BitmapData = new BitmapData(w, h);
      if (offset.y >= 0) 
      {
        tileY.copyPixels(_imageData, new Rectangle(0, 0, w, h - Math.abs(offset.y)), new Point(0, offset.y));
        tileY.copyPixels(_imageData, new Rectangle(0, h - offset.y, w, Math.abs(offset.y)), new Point());
      }
      else if (offset.y < 0)
      {
        tileY.copyPixels(_imageData, new Rectangle(0, Math.abs(offset.y), w, h - Math.abs(offset.y)), new Point());
        tileY.copyPixels(_imageData, new Rectangle(0, 0, w, Math.abs(offset.y)), new Point(0, h - Math.abs(offset.y)));
      }
      
      // Now tile image on the X-axis.
      var tileX:BitmapData = new BitmapData(w, h);
      if (offset.x >= 0)
      {
        tileX.copyPixels(tileY, new Rectangle(0, 0, w - Math.abs(offset.x), h), new Point(offset.x, 0));
        tileX.copyPixels(tileY, new Rectangle(w - offset.x, 0, Math.abs(offset.x), h), new Point());
      }
      else 
      {
        tileX.copyPixels(tileY, new Rectangle(Math.abs(offset.x), 0, w - Math.abs(offset.x), h), new Point());
        tileX.copyPixels(tileY, new Rectangle(0, 0, Math.abs(offset.x), h), new Point(w - Math.abs(offset.x), 0));
      }
      
      // Finally, fill the bounding area with the tiled bitmap.
      graphics.clear();
      graphics.beginBitmapFill(tileX);
      graphics.drawRect(0, 0, w, h);
      graphics.endFill();
    }
    
  }
}