package utils 
{
  /** 
   * A two-dimensional vector representation, because flash.geom.Point is weak. 
   */
  public class Vector2 
  {
    public var x:Number;
    
    public var y:Number;
    
    public function Vector2(x:Number = 0, y:Number = 0) 
    {
      this.x = x;
      this.y = y;
    }
    
    /** 
     * Gets the length of this vector. 
     */
    public function length():Number 
    {
      return Math.sqrt(x*x + y*y);
    }
    
    /** 
     * Gets the dot product of this and a given vector. 
     */
    public function dot(v:Vector2):Number 
    {
      return x * v.x + y * v.y;
    }
    
    /** 
     * Sets the values of this vector. 
     */
    public function put(x:Number, y:Number):void 
    {
      this.x = x;
      this.y = y;
    }
    
    /** 
     * Copies the values of a given vector. 
     */
    public function copy(v:Vector2):void 
    {
      this.x = v.x;
      this.y = v.y;
    }
    
    /** 
     * Normalizes this vector to either unit length or a given length in-place. 
     * 
     * @param r - the optional length to normalize to.
     */
    public function normalize(r:Number = 1.0):void 
    {
      var s:Number = r / length();
      
      x *= s;
      y *= s;
    }
    
    /** 
     * Scales this vector by a scalar in-place. 
     */
    public function scale(s:Number):void 
    {
      x *= s;
      y *= s;
    }
    
    /** 
     * Returns the result of adding a given vector as a new vector.
     */
    public function add(v:Vector2):Vector2 
    {
      return new Vector2(x + v.x, y + v.y);
    }
    
    /**
     * Returns the result of subtracting a given vector as a new vector.
     */
    public function subtract(v:Vector2):Vector2 
    {
      return new Vector2(x - v.x, y - v.y);
    }
    
    /**
     * Adds a given vector with a given scale in-place.
     */
    public function acc(v:Vector2, s:Number):void 
    {
      x += v.x * s;
      y += v.y * s;
    }
    
    /**
     * Sets this vector to be the zero vector.
     */
    public function zero():void 
    {
      x = y = 0;
    }
    
    /**
     * Gets a string representation of this vector as "(<x>,<y>)".
     */
    public function toString():String
    {
      return "(" + x + "," + y + ")";
    }
    
    /** 
     * Returns a random vector within unit circle. 
     * 
     * @param scale - the length of vector.
     * 
     * @return a vector with polar coordinates (scale, [0, 2pi]).
     */
    public static function randomUnitCircle(scale:Number = 1):Vector2 
    {
      var theta:Number = Math.random() * Math.PI * 2;
      
      var v:Vector2 = new Vector2(Math.sin(theta), Math.cos(theta));
      
      v.scale(scale);
      
      return v;
    }
  }
}